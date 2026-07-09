import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kamkor/core/app_icon/app_icon.dart';

/// Holds the selected launcher icon, persisted across launches (mirrors
/// `ThemeCubit`/`LocaleCubit`). The state is the *logical* choice; the native
/// launcher icon is switched via `flutter_dynamic_icon_plus`.
///
/// Platform notes baked into [select]:
/// * iOS applies the change immediately (the system shows its own confirmation
///   alert) and restores the default icon when `null` is passed.
/// * Android defers the swap until the app is removed from recents (the plugin
///   runs it from a service's `onTaskRemoved`), and cannot restore the launcher
///   `MainActivity` via `null` — hence the dedicated `.original` alias.
class AppIconCubit extends HydratedCubit<AppIcon> {
  AppIconCubit({@visibleForTesting TargetPlatform? platform})
      : _isIOS = (platform ?? defaultTargetPlatform) == TargetPlatform.iOS,
        super(AppIcon.original);

  final bool _isIOS;

  /// Whether the running device can change its launcher icon at all. Queried
  /// lazily so the picker can explain when it isn't available.
  Future<bool> get isSupported async {
    try {
      return await FlutterDynamicIconPlus.supportsAlternateIcons;
    } on Object catch (_) {
      return false;
    }
  }

  /// Applies [icon] as the launcher icon and remembers the choice. Returns
  /// `false` (without persisting) when the platform can't change icons or the
  /// native call fails. Re-selecting the current icon is a safe no-op — it
  /// also avoids an Android edge case where re-toggling the active alias can
  /// hide the launcher entry.
  Future<bool> select(AppIcon icon) async {
    if (icon == state) return true;
    try {
      if (!await FlutterDynamicIconPlus.supportsAlternateIcons) return false;
      await FlutterDynamicIconPlus.setAlternateIconName(
        iconName: icon.platformIconName(isIOS: _isIOS),
      );
      emit(icon);
      return true;
    } on Object catch (_) {
      return false;
    }
  }

  /// Android applies the swap only once the app is closed; the UI uses this to
  /// tell the user what to expect after picking a disguise.
  bool get appliesOnAppClose => !_isIOS;

  @override
  AppIcon fromJson(Map<String, dynamic> json) =>
      AppIcon.fromId(json['appIcon'] as String?);

  @override
  Map<String, dynamic> toJson(AppIcon state) => {'appIcon': state.name};
}
