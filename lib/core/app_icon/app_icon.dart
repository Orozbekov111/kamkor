/// A launcher icon the user can pick in Profile → «Иконка приложения».
///
/// [original] is the real Kamkor icon; the rest are *disguises* that make the
/// app look like an ordinary utility on the home screen — useful when it must
/// not be recognisable at a glance. Each value's [name] is the shared id used
/// across all three layers: the persisted preference, the iOS
/// `CFBundleAlternateIcons` key and the Android `.<name>` activity-alias.
enum AppIcon {
  original,
  calculator,
  notes,
  weather,
  clock,
  calendar,
  gallery;

  /// In-app preview thumbnail shown in the picker grid (see `pubspec.yaml`
  /// assets and `assets/app_icons/`). [original] maps to the Kamkor artwork.
  String get previewAsset =>
      'assets/app_icons/${this == AppIcon.original ? 'kamkor' : name}.png';

  /// The value passed to `FlutterDynamicIconPlus.setAlternateIconName`.
  ///
  /// For [original]: iOS restores the primary asset-catalog icon with `null`,
  /// while Android must re-enable the dedicated `.original` alias — passing
  /// `null` there is a no-op and would leave the disguise in place.
  String? platformIconName({required bool isIOS}) {
    if (this == AppIcon.original) return isIOS ? null : 'original';
    return name;
  }

  /// True for every icon except the real Kamkor one — i.e. the disguises.
  bool get isDisguise => this != AppIcon.original;

  static AppIcon fromId(String? id) => AppIcon.values.firstWhere(
        (i) => i.name == id,
        orElse: () => AppIcon.original,
      );
}
