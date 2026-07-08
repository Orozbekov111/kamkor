import 'dart:ui';

/// Global app configuration. Single backend, no flavors.
abstract final class AppConfig {
  static const String baseUrl = 'https://kamkor.mvd.kg';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// Hard upper bound on the startup session check, so the splash can never
  /// hang: it caps the sum of connect + receive legs and any local stalls.
  static const Duration sessionCheckTimeout = Duration(seconds: 20);
  static const Locale defaultLocale = Locale('ky');
}
