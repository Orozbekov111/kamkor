import 'package:flutter/material.dart';
import 'package:kamkor/core/theme/app_spacing.dart';

/// A small uppercase caption placed above a [CardGroup], in the grouped-list
/// idiom shared by Profile, the reference menu and history details.
///
/// Keeping one header widget means every screen labels its groups with the same
/// weight, color and letter-spacing — the visual "table of contents" reads the
/// same everywhere. (DESIGN_SYSTEM.md §6 — one component style app-wide.)
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// A flat, tonal card that stacks [rows] with hairline dividers between them —
/// the app-wide "grouped settings / grouped list" container.
///
/// Flat by design (elevation 0, tonal surface from [CardThemeData]) so the app
/// stays calm and low-noise (DESIGN_SYSTEM.md §6). The divider is inset by
/// [dividerIndent] so it starts under the row's text, aligned past the leading
/// icon — the same alignment on every screen.
class CardGroup extends StatelessWidget {
  const CardGroup({
    required this.rows,
    this.dividerIndent = AppSpacing.xxl + AppSpacing.xl,
    super.key,
  });

  final List<Widget> rows;

  /// Where the between-rows divider starts. Defaults to align past a leading
  /// icon; pass `0` for rows without a leading icon.
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, indent: dividerIndent),
            rows[i],
          ],
        ],
      ),
    );
  }
}

/// One row inside a [CardGroup]: a leading icon, a title, an optional secondary
/// [subtitle] or trailing [value], and (for navigation) a chevron.
///
/// This single tile covers the profile's setting rows, the reference menu and
/// any other grouped navigation so they are pixel-identical. Destructive rows
/// (sign out, delete) use the muted, non-SOS `error` role for both icon and
/// text — never a red fill, keeping red exclusive to SOS (DESIGN_SYSTEM.md §2).
class AppTile extends StatelessWidget {
  const AppTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    this.destructive = false,
    this.showChevron = true,
    super.key,
  });

  final IconData icon;
  final String title;

  /// Secondary line under the title (used by the reference menu).
  final String? subtitle;

  /// A current value shown on the trailing edge (used by preference rows).
  final String? value;

  /// A fully custom trailing widget; overrides [value] and the chevron.
  final Widget? trailing;

  final VoidCallback? onTap;
  final bool destructive;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = destructive ? scheme.error : scheme.onSurface;
    final iconColor = destructive ? scheme.error : scheme.onSurfaceVariant;
    final muted = scheme.onSurfaceVariant;

    var trailingWidget = trailing;
    if (trailingWidget == null && (value != null || showChevron)) {
      trailingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Flexible(
              child: Text(
                value!,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(color: muted),
              ),
            ),
          if (showChevron) ...[
            const SizedBox(width: AppSpacing.xs),
            Icon(Icons.chevron_right, color: muted),
          ],
        ],
      );
    }

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: foreground)),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(color: muted),
            ),
      trailing: trailingWidget,
      onTap: onTap,
    );
  }
}

/// A read-only "label over value" row for detail screens (e.g. an SOS history
/// record): a small muted label with the emphasized value beneath it, and an
/// optional [footer] for row-scoped actions. Lives inside a [CardGroup] so
/// detail screens share the grouped-card language with Profile and the menus.
class AppDetailTile extends StatelessWidget {
  const AppDetailTile({
    required this.icon,
    required this.label,
    required this.value,
    this.footer,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  /// Optional actions shown under the value (e.g. copy / open on map).
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ListTile(
      leading: Icon(icon, color: scheme.primary),
      title: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: theme.textTheme.bodyLarge),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.xs),
            footer!,
          ],
        ],
      ),
    );
  }
}
