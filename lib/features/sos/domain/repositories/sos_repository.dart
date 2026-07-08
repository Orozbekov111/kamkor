import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/sos/domain/entities/geo_point.dart';
import 'package:kamkor/features/sos/domain/entities/sos.dart';
import 'package:kamkor/features/sos/domain/entities/sos_readiness.dart';
import 'package:kamkor/features/sos/domain/entities/sos_signal.dart';

abstract interface class SosRepository {
  /// Checks/requests location access (mandatory) and captures the initial fix
  /// when location is granted.
  ResultFuture<SosReadiness> preflight();

  /// Creates the alarm from an initial fix and remembers it as active.
  ResultFuture<Sos> createSos(GeoPoint start);

  /// Pushes a position. A closed alarm (409) yields `Left(SosClosedFailure)`,
  /// which the caller must treat as a hard stop signal.
  ResultVoid updateLocation(String id, GeoPoint point);

  /// Fetches the alarm, used to restore/verify an alarm after a restart.
  ResultFuture<Sos> getSos(String id);

  /// Starts in-process location tracking, emitting a signal stream. Cancelling
  /// the returned subscription releases everything — the guaranteed teardown
  /// path relied on by the bloc. Location only flows while the app is in the
  /// foreground.
  Stream<SosSignal> startMonitoring({required String sosId});

  /// Opens the OS app-settings page (permission recovery).
  Future<void> openAppSettings();

  /// Opens the OS location-services page (service disabled recovery).
  Future<void> openLocationSettings();
}
