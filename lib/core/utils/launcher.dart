import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Thin wrapper over `url_launcher` that never throws: returns `false` when the
/// platform has no handler (e.g. a dialer/maps app is missing) so callers can
/// show a graceful fallback instead of crashing.
abstract final class Launcher {
  /// Opens the phone dialer pre-filled with [phoneNumber].
  static Future<bool> dial(String phoneNumber) =>
      _launch(Uri(scheme: 'tel', path: phoneNumber));

  /// Opens [latitude],[longitude] on a map, preferring the free 2GIS app and
  /// falling back to Google Maps (native app when installed, otherwise the web
  /// map) when 2GIS isn't available.
  ///
  /// Note: 2GIS deep links take longitude *before* latitude.
  static Future<bool> openMap(double latitude, double longitude) async {
    final dgis = Uri.parse('dgis://2gis.ru/geo/$longitude,$latitude');
    if (await _launch(dgis)) return true;
    return _launch(
      Uri.parse('https://maps.google.com/?q=$latitude,$longitude'),
    );
  }

  static Future<bool> _launch(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object catch (e) {
      debugPrint('Launcher failed for $uri: $e');
      return false;
    }
  }
}
