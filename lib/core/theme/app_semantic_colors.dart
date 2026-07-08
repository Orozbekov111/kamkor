import 'package:flutter/material.dart';

/// Brightness-aware semantic color roles that Material's [ColorScheme] does not
/// cover: the three unmistakable signals of the app plus success/warning.
///
/// Accessed via `Theme.of(context).extension<AppSemanticColors>()!`.
///
/// The three signals are deliberately kept distinct so none reads as another
/// (see DESIGN_SYSTEM.md §2). All values are contrast-checked, light and dark:
///
/// * [sos] — saturated RED. The one and only alarm-red in the app; the SOS
///   trigger. Never used for errors/destructive/status.
/// * [sosActive] — vivid, saturated GREEN. "Alarm is active, coordinates are
///   transmitting". Deliberately brighter/livelier than the calm brand green so
///   the active-alarm state never looks like ordinary UI.
/// * [success] — calm forest GREEN. Confirmations / "done". A different meaning
///   from [sosActive], so a different tone.
///
/// (Errors use the muted, non-alarm `ColorScheme.error`, never [sos].)
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.sos,
    required this.onSos,
    required this.sosActive,
    required this.onSosActive,
    required this.sosActiveContainer,
    required this.onSosActiveContainer,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
  });

  /// SOS trigger red — reserved exclusively for the SOS action.
  final Color sos;
  final Color onSos;

  /// Active-alarm green — vivid, distinct from the brand green.
  final Color sosActive;
  final Color onSosActive;
  final Color sosActiveContainer;
  final Color onSosActiveContainer;

  /// Confirmation / "done" green.
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  /// Attention (offline, needs-action) — amber, never red.
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  /// Light theme. Every text/UI pairing here meets WCAG 2.2 AA
  /// (text ≥ 4.5:1, large text / graphics ≥ 3:1).
  static const light = AppSemanticColors(
    sos: Color(0xFFD32029),
    onSos: Color(0xFFFFFFFF),
    sosActive: Color(0xFF0A7A3B),
    onSosActive: Color(0xFFFFFFFF),
    sosActiveContainer: Color(0xFFC9F2D6),
    onSosActiveContainer: Color(0xFF05391E),
    success: Color(0xFF2E7D32),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFC8E6C9),
    onSuccessContainer: Color(0xFF0B3D12),
    warning: Color(0xFF8A6D00),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFFF3CD),
    onWarningContainer: Color(0xFF4A3B00),
  );

  /// Dark theme — not an inversion. Greens/red are lightened so they keep
  /// ≥ 4.5:1 against the dark surface; `on*` flip to dark where needed.
  static const dark = AppSemanticColors(
    sos: Color(0xFFFF5A5F),
    onSos: Color(0xFF3A0A0C),
    sosActive: Color(0xFF43D982),
    onSosActive: Color(0xFF06301A),
    sosActiveContainer: Color(0xFF124A2C),
    onSosActiveContainer: Color(0xFFA6F2C4),
    success: Color(0xFF66BB6A),
    onSuccess: Color(0xFF06300B),
    successContainer: Color(0xFF1B4620),
    onSuccessContainer: Color(0xFFC8E6C9),
    warning: Color(0xFFE8C468),
    onWarning: Color(0xFF3A2E00),
    warningContainer: Color(0xFF4A3B00),
    onWarningContainer: Color(0xFFFFF3CD),
  );

  @override
  AppSemanticColors copyWith({
    Color? sos,
    Color? onSos,
    Color? sosActive,
    Color? onSosActive,
    Color? sosActiveContainer,
    Color? onSosActiveContainer,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
  }) {
    return AppSemanticColors(
      sos: sos ?? this.sos,
      onSos: onSos ?? this.onSos,
      sosActive: sosActive ?? this.sosActive,
      onSosActive: onSosActive ?? this.onSosActive,
      sosActiveContainer: sosActiveContainer ?? this.sosActiveContainer,
      onSosActiveContainer: onSosActiveContainer ?? this.onSosActiveContainer,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      sos: Color.lerp(sos, other.sos, t)!,
      onSos: Color.lerp(onSos, other.onSos, t)!,
      sosActive: Color.lerp(sosActive, other.sosActive, t)!,
      onSosActive: Color.lerp(onSosActive, other.onSosActive, t)!,
      sosActiveContainer:
          Color.lerp(sosActiveContainer, other.sosActiveContainer, t)!,
      onSosActiveContainer:
          Color.lerp(onSosActiveContainer, other.onSosActiveContainer, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
    );
  }
}

/// Ergonomic access to the semantic palette from any `BuildContext`.
extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get semantic =>
      Theme.of(this).extension<AppSemanticColors>()!;
}
