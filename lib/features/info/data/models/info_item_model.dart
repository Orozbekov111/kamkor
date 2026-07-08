import 'package:json_annotation/json_annotation.dart';

part 'info_item_model.g.dart';

/// Covers both public shapes: guides carry `content` + `created_at`, while the
/// privacy policy carries `text` and no timestamp.
@JsonSerializable(createToJson: false)
class InfoItemModel {
  const InfoItemModel({
    required this.id,
    required this.title,
    this.content,
    this.text,
    this.createdAt,
  });

  factory InfoItemModel.fromJson(Map<String, dynamic> json) =>
      _$InfoItemModelFromJson(json);

  final int id;
  final String title;
  final String? content;
  final String? text;
  @JsonKey(name: 'created_at')
  final String? createdAt;
}
