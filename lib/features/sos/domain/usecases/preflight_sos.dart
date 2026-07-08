import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/sos/domain/entities/sos_readiness.dart';
import 'package:kamkor/features/sos/domain/repositories/sos_repository.dart';

/// Location-access concern for the pre-alarm step: readiness check plus the
/// settings shortcuts the UI offers when access is missing.
class PreflightSos {
  const PreflightSos(this._repository);

  final SosRepository _repository;

  ResultFuture<SosReadiness> call() => _repository.preflight();

  Future<void> openAppSettings() => _repository.openAppSettings();

  Future<void> openLocationSettings() => _repository.openLocationSettings();
}
