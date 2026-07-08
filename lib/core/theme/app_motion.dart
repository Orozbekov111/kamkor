import 'package:flutter/widgets.dart';

/// Motion scale (DESIGN_SYSTEM.md §5): short, functional, no springs.
///
/// Durations are named so critical paths never grow "expressive". Every
/// consumer should route through [resolve] so the OS "reduce motion" setting is
/// honored (WCAG 2.3.3): when animations are disabled the app snaps instead of
/// animating.
abstract final class AppMotion {
  /// Ripples, control state changes.
  static const short = Duration(milliseconds: 150);

  /// State-to-state transitions (e.g. the SOS view's AnimatedSwitcher).
  static const medium = Duration(milliseconds: 250);

  /// Page transitions, sheet reveals.
  static const long = Duration(milliseconds: 300);

  /// The slow, reassuring active-alarm pulse. Never used elsewhere.
  static const pulse = Duration(milliseconds: 1800);

  /// Standard M3 easing. No elastic/bounce anywhere.
  static const Curve curve = Curves.easeInOut;
  static const Curve curveOut = Curves.easeOut;

  /// True when the user asked the OS to minimize motion.
  static bool reduceMotion(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  /// Collapses [duration] to zero when reduce-motion is on, so transitions are
  /// instant rather than animated.
  static Duration resolve(BuildContext context, Duration duration) =>
      reduceMotion(context) ? Duration.zero : duration;
}
