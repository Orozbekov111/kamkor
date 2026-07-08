import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:kamkor/features/sos/domain/entities/geo_point.dart';
import 'package:kamkor/features/sos/domain/entities/sos_readiness.dart';

/// Device-facing wrapper over `geolocator`. Owns permission handling and a
/// leak-free position stream. A single instance drives one alarm at a time;
/// [start] must always be balanced by [stop].
///
/// Location is only streamed while the app is in the foreground — there is no
/// background continuation. Sending pauses when the app is backgrounded and
/// resumes when it returns to the foreground.
class LocationTracker {
  /// Time-based cadence required by the SOS contract (every 15s), independent
  /// of movement — the server must always hold a recent fix.
  static const _interval = Duration(seconds: 15);

  static const _streamSettings =
      LocationSettings(accuracy: LocationAccuracy.high);

  StreamController<GeoPoint>? _controller;
  StreamSubscription<Position>? _positionSub;
  Timer? _timer;
  Position? _latest;

  /// Checks the location service and permission, requesting the latter once.
  Future<LocationReadiness> ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationReadiness.serviceDisabled;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return switch (permission) {
      LocationPermission.always ||
      LocationPermission.whileInUse =>
        LocationReadiness.ready,
      LocationPermission.deniedForever => LocationReadiness.deniedForever,
      LocationPermission.denied ||
      LocationPermission.unableToDetermine =>
        LocationReadiness.denied,
    };
  }

  /// One-shot fix for the alarm's initial geolocation. Falls back to the last
  /// known position rather than blocking the alarm if a live fix times out.
  Future<GeoPoint?> currentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      return _toGeoPoint(position);
    } on Exception {
      final last = await Geolocator.getLastKnownPosition();
      return last == null ? null : _toGeoPoint(last);
    }
  }

  /// Starts streaming positions at the 15s cadence. The continuous GPS stream
  /// only updates the latest fix; a periodic timer does the actual emitting.
  Stream<GeoPoint> start() {
    final controller = StreamController<GeoPoint>();
    _controller = controller;
    _positionSub =
        Geolocator.getPositionStream(locationSettings: _streamSettings)
        .listen(
          (position) {
            final isFirstFix = _latest == null;
            _latest = position;
            // Emit the first fix immediately so the UI confirms tracking fast.
            if (isFirstFix) _emit();
          },
          // A transient GPS error must not tear down an active alarm's stream.
          onError: (Object _) {},
        );
    _timer = Timer.periodic(_interval, (_) => _emit());
    return controller.stream;
  }

  void _emit() {
    final position = _latest;
    final controller = _controller;
    if (position == null || controller == null || controller.isClosed) return;
    controller.add(_toGeoPoint(position));
  }

  /// Cancels the timer and GPS subscription and closes the stream — the single
  /// path that releases the GPS sensor. Safe to call more than once.
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    _latest = null;
    await _positionSub?.cancel();
    _positionSub = null;
    final controller = _controller;
    _controller = null;
    await controller?.close();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  GeoPoint _toGeoPoint(Position position) => GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        capturedAt: position.timestamp,
      );
}
