// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthTokenModel _$AuthTokenModelFromJson(Map<String, dynamic> json) =>
    AuthTokenModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      authToken: json['auth_token'] as String?,
      sosButtonAvailable: json['sos_button_available'] as bool?,
    );

Map<String, dynamic> _$AuthTokenModelToJson(AuthTokenModel instance) =>
    <String, dynamic>{
      'auth_token': instance.authToken,
      'sos_button_available': instance.sosButtonAvailable,
      'user': instance.user,
    };
