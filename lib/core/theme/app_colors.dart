import 'package:flutter/material.dart';

/// Anchor color values that seed the Material 3 scheme.
///
/// Semantic, brightness-aware roles (SOS trigger, active-alarm, success,
/// warning) live in `AppSemanticColors`; everything else is derived by
/// `ColorScheme.fromSeed`. Only two raw anchors survive here:
///
/// * [brandGreen] — the calm, institutional primary. Normal UI, links,
///   selected tab. Trustworthy, never alarming.
/// * [sos] — the single saturated red in the whole app, reserved for the SOS
///   trigger button. Its meaning ("alarm — start") must never be diluted.
abstract final class AppColors {
  /// Seed + exact primary: deep, muted, institutional green.
  static const brandGreen = Color(0xFF1B6B47);

  /// Alarm accent — reserved exclusively for the SOS trigger control.
  static const sos = Color(0xFFD32029);
}
