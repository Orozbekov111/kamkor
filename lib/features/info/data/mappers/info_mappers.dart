import 'package:kamkor/features/info/data/models/info_item_model.dart';
import 'package:kamkor/features/info/domain/entities/info_item.dart';

extension InfoItemModelMapper on InfoItemModel {
  InfoItem toEntity() => InfoItem(
        id: id,
        title: title,
        // Guides use `content`; the privacy policy uses `text`.
        body: content ?? text ?? '',
        createdAt: createdAt == null ? null : DateTime.tryParse(createdAt!),
      );
}
