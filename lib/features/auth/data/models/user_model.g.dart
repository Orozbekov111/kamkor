// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  surname: json['surname'] as String?,
  phoneNumber: json['phone_number'] as String?,
  region: json['region'] as String?,
  uvdCode: json['uvd_code'] as String?,
  address: json['address'] as String?,
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'surname': instance.surname,
  'phone_number': instance.phoneNumber,
  'region': instance.region,
  'uvd_code': instance.uvdCode,
  'address': instance.address,
  'icon': instance.icon,
};
