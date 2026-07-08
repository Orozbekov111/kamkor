// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoItemModel _$InfoItemModelFromJson(Map<String, dynamic> json) =>
    InfoItemModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String?,
      text: json['text'] as String?,
      createdAt: json['created_at'] as String?,
    );
