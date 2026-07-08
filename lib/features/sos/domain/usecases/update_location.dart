import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/sos/domain/entities/geo_point.dart';
import 'package:kamkor/features/sos/domain/repositories/sos_repository.dart';

/// Pushes a position for the active alarm.
///
/// A `Left(SosClosedFailure)` is the "alarm closed" signal (409): the bloc must
/// stop tracking. Any other `Left` is transient and should be retried.
class UpdateLocation {
  const UpdateLocation(this._repository);

  final SosRepository _repository;

  ResultVoid call(String id, GeoPoint point) =>
      _repository.updateLocation(id, point);
}
