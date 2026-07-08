import 'package:kamkor/features/sos_history/data/models/sos_history_item_model.dart';
import 'package:kamkor/features/sos_history/domain/entities/sos_history_item.dart';

extension SosHistoryItemModelMapper on SosHistoryItemModel {
  SosHistoryItem toEntity() => SosHistoryItem(
        id: id,
        geo: geo,
        createdAt: createdAt == null ? null : DateTime.tryParse(createdAt!),
      );
}
