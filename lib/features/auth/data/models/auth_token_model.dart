import 'package:json_annotation/json_annotation.dart';
import 'package:kamkor/features/auth/data/models/user_model.dart';

part 'auth_token_model.g.dart';

/// Shared auth response DTO: `access-link/auth` fills [authToken],
/// `me` fills [sosButtonAvailable]; both carry [user].
@JsonSerializable()
class AuthTokenModel {
  const AuthTokenModel({
    required this.user,
    this.authToken,
    this.sosButtonAvailable,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);

  @JsonKey(name: 'auth_token')
  final String? authToken;
  @JsonKey(name: 'sos_button_available')
  final bool? sosButtonAvailable;
  final UserModel user;

  Map<String, dynamic> toJson() => _$AuthTokenModelToJson(this);
}
