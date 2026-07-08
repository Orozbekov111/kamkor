import 'package:json_annotation/json_annotation.dart';

part 'message_template_model.g.dart';

/// Mirrors the backend message-template object.
@JsonSerializable(createToJson: false)
class MessageTemplateModel {
  const MessageTemplateModel({
    required this.messageText,
    required this.geoSignature,
  });

  factory MessageTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$MessageTemplateModelFromJson(json);

  @JsonKey(name: 'message_text')
  final String messageText;
  @JsonKey(name: 'geo_signature')
  final String geoSignature;
}
