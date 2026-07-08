import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/sos/domain/entities/geo_point.dart';
import 'package:kamkor/features/sos/domain/entities/sos.dart';
import 'package:kamkor/features/sos/domain/repositories/sos_repository.dart';

/// Creates the alarm from the initial fix acquired during preflight.
class CreateSos {
  const CreateSos(this._repository);

  final SosRepository _repository;

  ResultFuture<Sos> call(GeoPoint start) => _repository.createSos(start);
}
