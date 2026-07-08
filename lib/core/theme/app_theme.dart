import 'package:flutter/material.dart';
import 'package:kamkor/core/theme/app_colors.dart';
import 'package:kamkor/core/theme/app_radius.dart';
import 'package:kamkor/core/theme/app_semantic_colors.dart';
import 'package:kamkor/core/theme/app_typography.dart';

/// Material 3 light/dark themes for KAMKOR.
///
/// A thin, calm layer over M3: green institutional brand, a muted (non-SOS)
/// error role so red stays unique to the alarm, flat surfaces (tonal elevation,
/// no shadows), tokenized radii and consistent component styling. Semantic
/// signal colors live in [AppSemanticColors], registered as a theme extension.
abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final semantic = isDark ? AppSemanticColors.dark : AppSemanticColors.light;

    // Green seed for a trustworthy, institutional feel. `primary`/`onPrimary`
    // are pinned to the exact brand green so the "calm green" signal (buttons,
    // selected tab, links) is stable and contrast-checked; `error` is pinned to
    // a muted, non-alarm red so it can never be mistaken for the SOS red.
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.brandGreen,
      brightness: brightness,
    );
    final scheme = isDark
        ? base.copyWith(
            primary: const Color(0xFF7FD6AB),
            onPrimary: const Color(0xFF0A3322),
            error: const Color(0xFFF2B8B5),
            onError: const Color(0xFF601410),
          )
        : base.copyWith(
            primary: AppColors.brandGreen,
            onPrimary: const Color(0xFFFFFFFF),
            error: const Color(0xFFB3352C),
            onError: const Color(0xFFFFFFFF),
          );

    final textTheme = AppTypography.textTheme.apply(
      fontFamily: AppTypography.fontFamily,
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      extensions: [semantic],

      // Flat by default: rely on tonal color, not shadows. Calm, low-noise.
      // A single hairline divider (not a shadow) sets the bar apart from the
      // content below it — enough separation without adding elevation noise.
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        shape: Border(bottom: BorderSide(color: scheme.outlineVariant)),
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brSm),
        ),
      ),
      // Language selector and any future segmented control: one calm look, a
      // ≥48dp tap target, and the shared label style.
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(borderRadius: AppRadius.brSm),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.brSm,
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.brSm,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        alignLabelWithHint: true,
        helperMaxLines: 3,
      ),

      listTileTheme: const ListTileThemeData(
        minVerticalPadding: 12,
      ),
      dividerTheme: DividerThemeData(
        space: 1,
        thickness: 1,
        color: scheme.outlineVariant,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        elevation: 0,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        elevation: 0,
        indicatorColor: scheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      // One calm shared page transition, honoring reduce-motion is handled by
      // the framework (durations collapse when animations are disabled).
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
