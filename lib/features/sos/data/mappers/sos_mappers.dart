import 'package:kamkor/features/sos/data/models/location_model.dart';
import 'package:kamkor/features/sos/data/models/sos_model.dart';
import 'package:kamkor/features/sos/domain/entities/geo_point.dart';
import 'package:kamkor/features/sos/domain/entities/sos.dart';
import 'package:kamkor/features/sos/domain/entities/sos_status.dart';

/// 6 decimals ≈ 0.11 m precision — plenty for a rescue, and keeps the string
/// compact. This is the single place that knows the `"lat, lng"` wire format.
String formatGeolocation(GeoPoint point) =>
    '${point.latitude.toStringAsFixed(6)}, '
    '${point.longitude.toStringAsFixed(6)}';

/// Parses the server's `"lat, lng"` string; returns null on any malformed input
/// so a bad payload never crashes the alarm.
GeoPoint? parseGeolocation(String? raw) {
  if (raw == null) return null;
  final parts = raw.split(',');
  if (parts.length != 2) return null;
  final lat = double.tryParse(parts[0].trim());
  final lng = double.tryParse(parts[1].trim());
  if (lat == null || lng == null) return null;
  return GeoPoint(latitude: lat, longitude: lng);
}

extension GeoPointMapper on GeoPoint {
  LocationModel toLocationModel() => LocationModel(
        latitude: latitude,
        longitude: longitude,
        accuracy: accuracy,
        capturedAt: capturedAt?.toUtc().toIso8601String(),
      );
}

extension SosModelMapper on SosModel {
  Sos toEntity() => Sos(
        // `sos_id` (create) and `id` (get) are the same identifier.
        id: (id ?? sosId).toString(),
        status: SosStatus.fromApi(status),
        createdAt: createdAt == null ? null : DateTime.tryParse(createdAt!),
        initialLocation: parseGeolocation(geo),
      );
}
