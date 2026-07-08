import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/sos/domain/entities/sos.dart';
import 'package:kamkor/features/sos/domain/repositories/sos_repository.dart';

/// Fetches an alarm by id — used to restore/verify a persisted active alarm
/// after the app is relaunched.
class GetSos {
  const GetSos(this._repository);

  final SosRepository _repository;

  ResultFuture<Sos> call(String id) => _repository.getSos(id);
}
