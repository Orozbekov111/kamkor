import 'package:flutter/material.dart';

/// Typography tuned for readability under stress: larger sizes, strong weights,
/// generous line-height. Scale gaps are filled so Material defaults never leak
/// in with a different weight (DESIGN_SYSTEM.md §3).
abstract final class AppTypography {
  /// Bundled Noto Sans (variable, wght 100–900). Chosen for full Kyrgyz
  /// Cyrillic coverage (Ң Ү Ө ң ү ө) and a calm, neutral grotesque with no
  /// "character". Bundled as a static asset — never fetched over the network
  /// (the app must work offline in a crisis).
  static const fontFamily = 'NotoSans';

  static const TextTheme textTheme = TextTheme(
    // Reserved for the SOS button label only.
    displaySmall: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    bodyLarge: TextStyle(fontSize: 18, height: 1.4),
    bodyMedium: TextStyle(fontSize: 16, height: 1.4),
    // Secondary/service captions only — never primary reading text.
    bodySmall: TextStyle(fontSize: 14, height: 1.4),
    labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
  );
}
