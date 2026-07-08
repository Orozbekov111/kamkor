import 'package:json_annotation/json_annotation.dart';

part 'contact_model.g.dart';

/// Mirrors the backend trusted-contact object.
@JsonSerializable()
class ContactModel {
  const ContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  final int id;
  final String name;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
}
