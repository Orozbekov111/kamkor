import 'dart:async';
import 'dart:math' as math;

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kamkor/core/error/failures.dart';
import 'package:kamkor/features/sos/domain/entities/geo_point.dart';
import 'package:kamkor/features/sos/domain/entities/sos.dart';
import 'package:kamkor/features/sos/domain/entities/sos_readiness.dart';
import 'package:kamkor/features/sos/domain/entities/sos_signal.dart';
import 'package:kamkor/features/sos/domain/entities/sos_status.dart';
import 'package:kamkor/features/sos/domain/usecases/create_sos.dart';
import 'package:kamkor/features/sos/domain/usecases/get_sos.dart';
import 'package:kamkor/features/sos/domain/usecases/preflight_sos.dart';
import 'package:kamkor/features/sos/domain/usecases/update_location.dart';
import 'package:kamkor/features/sos/domain/usecases/watch_sos_status.dart';

part 'sos_event.dart';
part 'sos_state.dart';

/// Owns the full alarm lifecycle:
/// idle → activating → active → closed/failure.
///
/// It is a [HydratedBloc] so an active alarm survives an app restart: the
/// active [Sos] id is persisted and, on relaunch, monitoring is resumed and the
/// first server round-trip re-confirms the alarm (or a 409 closes it).
///
/// Resource safety is centralised in [_teardown]: cancelling the single
/// monitoring subscription triggers the repository's `onCancel`, which stops
/// GPS. It runs on close, on a 409, and on any failure.
class SosBloc extends HydratedBloc<SosEvent, SosState> {
  SosBloc({
    required PreflightSos preflight,
    required CreateSos createSos,
    required UpdateLocation updateLocation,
    required WatchSosStatus watchSosStatus,
    required GetSos getSos,
  })  : _preflight = preflight,
        _createSos = createSos,
        _updateLocation = updateLocation,
        _watchSosStatus = watchSosStatus,
        _getSos = getSos,
        super(const SosIdle()) {
    // droppable: a second tap during activation is ignored — never two alarms.
    on<SosTriggered>(_onTriggered, transformer: droppable());
    on<SosRestoreRequested>(_onRestoreRequested);
    on<SosDismissed>(_onDismissed);
    on<SosAppSettingsRequested>((_, _) => _preflight.openAppSettings());
    on<SosLocationServiceRequested>(
      (_, _) => _preflight.openLocationSettings(),
    );
    on<_LocationTick>(_onLocationTick);
    on<_SosClosedDetected>(_onClosedDetected);

    // Reading `state` triggers hydration; resume a persisted alarm if present.
    if (state is SosActive) {
      add(const SosRestoreRequested());
    }
  }

  final PreflightSos _preflight;
  final CreateSos _createSos;
  final UpdateLocation _updateLocation;
  final WatchSosStatus _watchSosStatus;
  final GetSos _getSos;

  StreamSubscription<SosSignal>? _signalsSub;

  Future<void> _onTriggered(SosTriggered event, Emitter<SosState> emit) async {
    // Second guard (beyond droppable): don't restart an already-active alarm.
    if (state is SosActivating || state is SosActive) return;
    emit(const SosActivating());

    final readiness = await _preflight();
    await readiness.fold(
      (failure) async => emit(SosFailure(_activationError(failure))),
      (ready) async {
        if (!ready.canStart) {
          emit(SosPermissionRequired(_permissionReason(ready.location)));
          return;
        }
        final start = ready.initialLocation;
        if (start == null) {
          emit(const SosFailure(SosActivationError.locationUnavailable));
          return;
        }
        await _createPersistently(start: start, emit: emit);
      },
    );
  }

  /// Persistently create the alarm: in a real emergency a transient network
  /// failure must NOT dead-end at "tap retry" — we keep retrying automatically
  /// until the alarm exists, then hand off to the normal monitoring path.
  ///
  /// This whole loop runs inside the single [SosTriggered] handler invocation,
  /// so `droppable()` + the `state is SosActivating` guard keep a second tap
  /// from ever starting a second creation. Only createSos is retried; preflight/
  /// permission/location failures are handled by the caller and never reach here.
  Future<void> _createPersistently({
    required GeoPoint start,
    required Emitter<SosState> emit,
  }) async {
    var attempt = 0;
    while (true) {
      // The only teardown hook for the creation phase: once the bloc is closed
      // (process shutdown) the emitter is done. Nothing is allocated yet here
      // (no subscription/service), so there is nothing to release — just stop
      // and never emit into a dead emitter. No "hanging" retries survive close.
      if (emit.isDone) return;
      final created = await _createSos(start);
      if (emit.isDone) return; // closed while the request was in flight

      final done = await created.fold(
        (failure) async {
          // Non-transient (401/422/other 4xx incl. a 409 on create): retrying
          // cannot help — surface it, don't storm the server.
          if (!_isRetriable(failure)) {
            emit(SosFailure(_activationError(failure)));
            return true;
          }
          // Transient: stay in activation, bump the attempt so the UI can be
          // honest ("still sending, retrying…"), then back off and retry.
          attempt++;
          emit(SosActivating(attempt: attempt));
          await Future<void>.delayed(_activationBackoff(attempt));
          return false;
        },
        (sos) async {
          // createSos already stored the initial fix → lastSentAt = now.
          // Seamless hand-off to the existing active/monitoring path.
          emit(
            SosActive(
              sos: sos,
              connection: SosConnection.online,
              lastSentAt: DateTime.now(),
            ),
          );
          await _startMonitoring(sosId: sos.id);
          return true;
        },
      );
      if (done) return;
    }
  }

  /// Retry only truly transient failures (connectivity / server availability).
  /// Auth/validation/other 4xx (including a 409 on create) are terminal — a
  /// retry would be futile and would hammer the server.
  bool _isRetriable(Failure failure) => switch (failure) {
        NetworkFailure() => true,
        TimeoutFailure() => true,
        ServerFailure(:final httpCode) => httpCode == null || httpCode >= 500,
        _ => false,
      };

  /// 2s → 3s → 4.5s … capped at 15s. Frequent enough for an emergency, but the
  /// cap keeps it from becoming a request storm / battery drain when the
  /// network stays down. We never stop retrying while the process lives.
  Duration _activationBackoff(int attempt) {
    final seconds = (2 * math.pow(1.5, attempt - 1)).clamp(2, 15).round();
    return Duration(seconds: seconds);
  }

  Future<void> _onRestoreRequested(
    SosRestoreRequested event,
    Emitter<SosState> emit,
  ) async {
    final restored = state;
    if (restored is! SosActive) return;
    // Until the first tick lands, present the alarm as reconnecting.
    emit(restored.copyWith(connection: SosConnection.reconnecting));
    await _startMonitoring(sosId: restored.sos.id);
    // Best-effort: if the server already reports the alarm closed, stop now
    // instead of waiting for the first location tick's 409.
    final fresh = await _getSos(restored.sos.id);
    fresh.fold(
      (_) {},
      (sos) {
        if (sos.status.isClosed) {
          add(const _SosClosedDetected(SosCloseReason.ended));
        }
      },
    );
  }

  Future<void> _onLocationTick(
    _LocationTick event,
    Emitter<SosState> emit,
  ) async {
    final current = state;
    if (current is! SosActive) return;
    final result = await _updateLocation(current.sos.id, event.point);
    result.fold(
      (failure) {
        if (failure is SosClosedFailure) {
          add(const _SosClosedDetected(SosCloseReason.ended));
          return;
        }
        // Transient network error: keep the alarm alive, show "reconnecting".
        // The next 15s tick retries automatically with a fresh position.
        final latest = state;
        if (latest is SosActive) {
          emit(latest.copyWith(connection: SosConnection.reconnecting));
        }
      },
      (_) {
        final latest = state;
        if (latest is SosActive) {
          emit(
            latest.copyWith(
              connection: SosConnection.online,
              lastSentAt: DateTime.now(),
            ),
          );
        }
      },
    );
  }

  Future<void> _onClosedDetected(
    _SosClosedDetected event,
    Emitter<SosState> emit,
  ) async {
    if (state is SosClosed) return;
    await _teardown();
    emit(SosClosed(event.reason));
  }

  Future<void> _onDismissed(SosDismissed event, Emitter<SosState> emit) async {
    await _teardown();
    emit(const SosIdle());
  }

  Future<void> _startMonitoring({required String sosId}) async {
    await _signalsSub?.cancel();
    _signalsSub = _watchSosStatus(sosId: sosId).listen((signal) {
      switch (signal) {
        case LocationSignal(:final point):
          add(_LocationTick(point));
      }
    });
  }

  /// Single teardown path: cancelling the subscription triggers the
  /// repository's `onCancel`, which stops GPS. Idempotent.
  Future<void> _teardown() async {
    await _signalsSub?.cancel();
    _signalsSub = null;
  }

  SosActivationError _activationError(Failure failure) => switch (failure) {
        NetworkFailure() => SosActivationError.network,
        TimeoutFailure() => SosActivationError.timeout,
        ServerFailure() => SosActivationError.server,
        UnauthorizedFailure() => SosActivationError.unauthorized,
        _ => SosActivationError.unknown,
      };

  SosPermissionReason _permissionReason(LocationReadiness readiness) =>
      switch (readiness) {
        LocationReadiness.serviceDisabled =>
          SosPermissionReason.serviceDisabled,
        LocationReadiness.deniedForever => SosPermissionReason.deniedForever,
        LocationReadiness.ready ||
        LocationReadiness.denied =>
          SosPermissionReason.denied,
      };

  @override
  Future<void> close() async {
    // Guarantees devices are released even if the bloc is disposed mid-alarm.
    await _teardown();
    return super.close();
  }

  // Only an active alarm is persisted; every other state clears storage.
  @override
  SosState? fromJson(Map<String, dynamic> json) {
    final id = json['sosId'] as String?;
    if (id == null) return null;
    return SosActive(
      sos: Sos(
        id: id,
        status: SosStatus.pending,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      ),
      connection: SosConnection.reconnecting,
    );
  }

  @override
  Map<String, dynamic>? toJson(SosState state) {
    if (state is! SosActive) return null;
    return {
      'sosId': state.sos.id,
      'createdAt': state.sos.createdAt?.toIso8601String(),
    };
  }
}
