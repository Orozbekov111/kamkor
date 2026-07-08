import 'package:json_annotation/json_annotation.dart';

part 'sos_history_item_model.g.dart';

/// A single SOS-history entry from `GET /api/sos` (and `GET /api/sos/{id}`).
@JsonSerializable(createToJson: false)
class SosHistoryItemModel {
  const SosHistoryItemModel({
    required this.id,
    this.geo,
    this.createdAt,
  });

  factory SosHistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$SosHistoryItemModelFromJson(json);

  final int id;
  final String? geo;
  @JsonKey(name: 'created_at')
  final String? createdAt;
}

/// Envelope for the list response: `{ success, data: [...] }`.
@JsonSerializable(createToJson: false)
class SosHistoryListResponse {
  const SosHistoryListResponse({this.data = const [], this.success});

  factory SosHistoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$SosHistoryListResponseFromJson(json);

  final bool? success;
  final List<SosHistoryItemModel> data;
}
