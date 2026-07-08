// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_history_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SosHistoryItemModel _$SosHistoryItemModelFromJson(Map<String, dynamic> json) =>
    SosHistoryItemModel(
      id: (json['id'] as num).toInt(),
      geo: json['geo'] as String?,
      createdAt: json['created_at'] as String?,
    );

SosHistoryListResponse _$SosHistoryListResponseFromJson(
  Map<String, dynamic> json,
) => SosHistoryListResponse(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => SosHistoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  success: json['success'] as bool?,
);
