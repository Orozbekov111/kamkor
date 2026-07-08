import 'package:equatable/equatable.dart';

/// A single geolocation sample captured on the device.
class GeoPoint extends Equatable {
  const GeoPoint({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.capturedAt,
  });

  final double latitude;
  final double longitude;

  /// Horizontal accuracy in meters, when the platform reports it.
  final double? accuracy;
  final DateTime? capturedAt;

  @override
  List<Object?> get props => [latitude, longitude, accuracy, capturedAt];
}
