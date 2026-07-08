import 'package:kamkor/features/sos/domain/entities/geo_point.dart';

/// Whether the device can start location tracking, and why not if it can't.
enum LocationReadiness {
  ready,
  serviceDisabled,
  denied,
  deniedForever,
}

/// Outcome of the pre-alarm preflight.
///
/// Location is mandatory (the alarm transmits coordinates).
class SosReadiness {
  const SosReadiness({
    required this.location,
    this.initialLocation,
  });

  final LocationReadiness location;

  /// The current fix, obtained once location access is granted. Used as the
  /// alarm's initial geolocation. Null if a fix could not be acquired.
  final GeoPoint? initialLocation;

  bool get canStart => location == LocationReadiness.ready;
}
