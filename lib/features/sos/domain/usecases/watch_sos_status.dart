import 'package:kamkor/features/sos/domain/entities/sos_signal.dart';
import 'package:kamkor/features/sos/domain/repositories/sos_repository.dart';

/// Opens the live monitoring stream (positions) for the active alarm. The
/// bloc's single subscription to this stream is also the resource lifeline:
/// cancelling it stops GPS.
class WatchSosStatus {
  const WatchSosStatus(this._repository);

  final SosRepository _repository;

  Stream<SosSignal> call({required String sosId}) =>
      _repository.startMonitoring(sosId: sosId);
}
