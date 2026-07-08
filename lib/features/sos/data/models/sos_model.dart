import 'package:json_annotation/json_annotation.dart';

part 'sos_model.g.dart';

/// Tolerant DTO covering both SOS responses:
/// `POST /api/sos` → `{ success, sos_id, status, message }` and
/// `GET /api/sos/{id}` → `{ id, created_at, geo, status? }`.
@JsonSerializable(createToJson: false)
class SosModel {
  const SosModel({
    this.id,
    this.sosId,
    this.status,
    this.createdAt,
    this.geo,
  });

  factory SosModel.fromJson(Map<String, dynamic> json) =>
      _$SosModelFromJson(json);

  // ids are read as `Object?` so a numeric or string id both parse cleanly.
  final Object? id;
  @JsonKey(name: 'sos_id')
  final Object? sosId;
  final String? status;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  /// Server-formatted `"lat, lng"` geolocation string.
  final String? geo;
}
