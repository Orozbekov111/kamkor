import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/app_icon/app_icon.dart';
import 'package:kamkor/core/app_icon/app_icon_cubit.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_radius.dart';
import 'package:kamkor/core/theme/app_spacing.dart';

/// Localized label for an [AppIcon]. Shared by the picker grid and the Profile
/// row that shows the current selection.
String appIconLabel(AppLocalizations l, AppIcon icon) => switch (icon) {
      AppIcon.original => l.app_icon_original,
      AppIcon.calculator => l.app_icon_calculator,
      AppIcon.notes => l.app_icon_notes,
      AppIcon.weather => l.app_icon_weather,
      AppIcon.clock => l.app_icon_clock,
      AppIcon.calendar => l.app_icon_calendar,
      AppIcon.gallery => l.app_icon_gallery,
    };

/// Opens the app-icon chooser. The app-wide [AppIconCubit] is passed down so
/// the sheet (hosted by the root navigator) can read and update the selection.
Future<void> showAppIconSheet(BuildContext context) {
  final cubit = context.read<AppIconCubit>();
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: const _AppIconSheet(),
    ),
  );
}

/// A grid of launcher-icon options with live previews. One tap applies the
/// choice and closes; a snackbar then explains what to expect (immediate on
/// iOS, after closing the app on Android).
class _AppIconSheet extends StatelessWidget {
  const _AppIconSheet();

  Future<void> _apply(BuildContext context, AppIcon icon) async {
    final l = AppLocalizations.of(context);
    final cubit = context.read<AppIconCubit>();
    final messenger = ScaffoldMessenger.of(context);
    // Capture everything that needs `context` before the await / pop.
    final failed = l.profile_app_icon_failed;
    final afterClose = l.profile_app_icon_android_hint;
    final changed = l.profile_app_icon_changed;
    final appliesOnClose = cubit.appliesOnAppClose;

    Navigator.of(context).pop();
    final ok = await cubit.select(icon);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          !ok
              ? failed
              : appliesOnClose
                  ? afterClose
                  : changed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xs,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: BlocBuilder<AppIconCubit, AppIcon>(
          builder: (context, selected) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.profile_app_icon, style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l.profile_app_icon_hint,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.lg,
                  crossAxisSpacing: AppSpacing.lg,
                  childAspectRatio: 0.82,
                  children: [
                    for (final icon in AppIcon.values)
                      _IconTile(
                        icon: icon,
                        label: appIconLabel(l, icon),
                        selected: icon == selected,
                        onTap: () => unawaited(_apply(context, icon)),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final AppIcon icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: selected
                            ? scheme.primary
                            : scheme.outlineVariant,
                        width: selected ? 2.5 : 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Image.asset(
                        icon.previewAsset,
                        fit: BoxFit.cover,
                        // Decorative; the tile's label carries the meaning.
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                  if (selected)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: scheme.surface, width: 2),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.check,
                          size: 14,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: selected ? scheme.primary : scheme.onSurface,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
