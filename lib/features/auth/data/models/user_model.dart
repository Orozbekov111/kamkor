import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// Mirrors the backend `user` object exactly.
@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    this.surname,
    this.phoneNumber,
    this.region,
    this.uvdCode,
    this.address,
    this.icon,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final int id;
  final String name;
  final String? surname;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? region;
  @JsonKey(name: 'uvd_code')
  final String? uvdCode;
  final String? address;
  final String? icon;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
