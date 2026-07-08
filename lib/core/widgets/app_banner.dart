import 'package:flutter/material.dart';
import 'package:kamkor/core/theme/app_radius.dart';
import 'package:kamkor/core/theme/app_semantic_colors.dart';
import 'package:kamkor/core/theme/app_spacing.dart';

/// Severity of an [AppBanner]. Never `error`/red — that stays exclusive to SOS
/// (DESIGN_SYSTEM.md §2).
enum AppBannerKind {
  /// Neutral context (calm `secondaryContainer`).
  info,

  /// Needs attention, not an error — offline, degraded data (amber `warning`).
  attention,
}

/// A single, non-blocking banner: an icon paired with a line of text on a
/// tonal, tokenized-radius surface. The one banner style in the app, so offline
/// notices, sync hints and info callouts all look identical (DESIGN_SYSTEM.md
/// §6). Always icon + text — meaning never rides on color alone (WCAG 1.4.1).
class AppBanner extends StatelessWidget {
  const AppBanner({
    required this.text,
    required this.icon,
    this.kind = AppBannerKind.info,
    super.key,
  });

  const AppBanner.info({
    required String text,
    IconData icon = Icons.info_outline,
    Key? key,
  }) : this(text: text, icon: icon, kind: AppBannerKind.info, key: key);

  const AppBanner.attention({
    required String text,
    IconData icon = Icons.wifi_off,
    Key? key,
  }) : this(text: text, icon: icon, kind: AppBannerKind.attention, key: key);

  final String text;
  final IconData icon;
  final AppBannerKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semantic;

    final (background, foreground) = switch (kind) {
      AppBannerKind.info => (
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
        ),
      AppBannerKind.attention => (
          semantic.warningContainer,
          semantic.onWarningContainer,
        ),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        children: [
          Icon(icon, color: foreground),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
