import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/sos_history/domain/entities/sos_history_item.dart';
import 'package:kamkor/features/sos_history/domain/repositories/sos_history_repository.dart';

class GetSosHistory {
  const GetSosHistory(this._repository);

  final SosHistoryRepository _repository;

  ResultFuture<List<SosHistoryItem>> call() => _repository.getHistory();
}
