import 'package:kamkor/features/sos/domain/entities/geo_point.dart';

/// A single event produced by the device while an alarm is active.
sealed class SosSignal {
  const SosSignal();
}

/// A fresh position fix that must be pushed to the server.
class LocationSignal extends SosSignal {
  const LocationSignal(this.point);

  final GeoPoint point;
}
