import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/sos_history/domain/entities/sos_history_item.dart';
import 'package:kamkor/features/sos_history/domain/repositories/sos_history_repository.dart';

class GetSosHistoryItem {
  const GetSosHistoryItem(this._repository);

  final SosHistoryRepository _repository;

  ResultFuture<SosHistoryItem> call(int id) => _repository.getHistoryItem(id);
}
