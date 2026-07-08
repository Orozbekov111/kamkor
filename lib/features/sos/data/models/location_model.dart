import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

/// Request body for `POST /api/sos/{id}/location`.
@JsonSerializable(createFactory: false)
class LocationModel {
  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.capturedAt,
  });

  final double latitude;
  final double longitude;
  @JsonKey(includeIfNull: false)
  final double? accuracy;

  /// ISO-8601 capture time, omitted when the platform gave no timestamp.
  @JsonKey(name: 'captured_at', includeIfNull: false)
  final String? capturedAt;

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
