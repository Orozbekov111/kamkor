import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:kamkor/core/error/exceptions.dart';
import 'package:kamkor/core/error/failure_mapper.dart';
import 'package:kamkor/core/error/failures.dart';
import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/sos/data/datasources/sos_remote_data_source.dart';
import 'package:kamkor/features/sos/data/mappers/sos_mappers.dart';
import 'package:kamkor/features/sos/domain/entities/geo_point.dart';
import 'package:kamkor/features/sos/domain/entities/sos.dart';
import 'package:kamkor/features/sos/domain/entities/sos_readiness.dart';
import 'package:kamkor/features/sos/domain/entities/sos_signal.dart';
import 'package:kamkor/features/sos/domain/repositories/sos_repository.dart';
import 'package:kamkor/features/sos/service/location_tracker.dart';

class SosRepositoryImpl implements SosRepository {
  SosRepositoryImpl(
    this._remote,
    this._location,
  );

  final SosRemoteDataSource _remote;
  final LocationTracker _location;

  // Monitoring session — kept so teardown releases the GPS source.
  StreamController<SosSignal>? _monitor;
  StreamSubscription<GeoPoint>? _locationSub;

  @override
  ResultFuture<SosReadiness> preflight() async {
    try {
      final location = await _location.ensurePermission();
      if (location != LocationReadiness.ready) {
        return Right(SosReadiness(location: location));
      }
      // Location granted: acquire the initial fix.
      final initial = await _location.currentPosition();
      return Right(
        SosReadiness(
          location: LocationReadiness.ready,
          initialLocation: initial,
        ),
      );
    } on Exception {
      return const Left(UnknownFailure('Не удалось подготовить тревогу'));
    }
  }

  @override
  ResultFuture<Sos> createSos(GeoPoint start) async {
    try {
      final model = await _remote.createSos(start);
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  ResultVoid updateLocation(String id, GeoPoint point) async {
    try {
      await _remote.updateLocation(id, point);
      return const Right(null);
    } on SosClosedException {
      return const Left(SosClosedFailure());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  ResultFuture<Sos> getSos(String id) async {
    try {
      final model = await _remote.getSos(id);
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Stream<SosSignal> startMonitoring({required String sosId}) {
    final controller = StreamController<SosSignal>();
    _monitor = controller;
    _locationSub = _location.start().listen(
          (point) => controller.add(LocationSignal(point)),
        );
    // Teardown is bound to the subscription lifecycle: whoever cancels the
    // stream (409 handler or bloc.close) releases the GPS source.
    controller.onCancel = _stopMonitoring;
    return controller.stream;
  }

  Future<void> _stopMonitoring() async {
    await _locationSub?.cancel();
    _locationSub = null;
    await _location.stop();
    final controller = _monitor;
    _monitor = null;
    if (controller != null && !controller.isClosed) await controller.close();
  }

  @override
  Future<void> openAppSettings() => _location.openAppSettings();

  @override
  Future<void> openLocationSettings() => _location.openLocationSettings();
}
