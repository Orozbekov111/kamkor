import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/sos_history/domain/entities/sos_history_item.dart';

abstract interface class SosHistoryRepository {
  /// The user's past SOS requests, newest first (as ordered by the backend).
  ResultFuture<List<SosHistoryItem>> getHistory();

  /// A single past SOS request by id.
  ResultFuture<SosHistoryItem> getHistoryItem(int id);
}
