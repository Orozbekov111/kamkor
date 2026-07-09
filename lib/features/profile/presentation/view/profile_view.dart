import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/app_icon/app_icon.dart';
import 'package:kamkor/core/app_icon/app_icon_cubit.dart';
import 'package:kamkor/core/di/injection.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/localization/locale_cubit.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/theme/theme_cubit.dart';
import 'package:kamkor/core/widgets/card_group.dart';
import 'package:kamkor/core/widgets/state_views/loading_view.dart';
import 'package:kamkor/features/auth/domain/entities/user.dart';
import 'package:kamkor/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kamkor/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:kamkor/features/profile/presentation/widgets/app_icon_sheet.dart';
import 'package:kamkor/features/profile/presentation/widgets/profile_edit_sheet.dart';

/// Profile screen, laid out as a calm "settings" surface:
///
/// * a centered identity header (avatar + name + contacts),
/// * grouped setting rows (account, preferences) that open a bottom-sheet
///   picker on tap — one value visible at a time, no dense inline controls,
/// * a sign-out row in the muted (non-SOS) error tone.
///
/// The grouping and single-value-at-a-glance rows keep the screen quiet: a
/// person under stress sees the current state, not a wall of options.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  void _openEditor(BuildContext context, User user) {
    final bloc = context.read<ProfileBloc>();
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: ProfileEditSheet(user: user),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final authBloc = context.read<AuthBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.profile_logout_title),
        content: Text(l.profile_logout_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.cancel),
          ),
          // Destructive: a text button in the muted (non-SOS) error tone with
          // an icon — never a solid red fill (red belongs to SOS only). The
          // dialog message already warns that sign-out ends SOS access.
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: scheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            icon: const Icon(Icons.logout),
            label: Text(l.profile_logout),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      // Clear session-scoped singletons (e.g. SosBloc) before signing out, so
      // no state leaks into the next session. The router reacts to logout.
      await resetSessionState();
      authBloc.add(const AuthLoggedOut());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.profile_title)),
      body: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == ProfileOpStatus.success) {
            // Propagate the refreshed user to the whole app.
            final session = state.session;
            if (session != null) {
              context.read<AuthBloc>().add(AuthLoggedIn(session));
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.profile_saved)),
            );
            context.read<ProfileBloc>().add(const ProfileOpReset());
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            // Signed out (logout in progress): the router is navigating away,
            // so render nothing rather than spinning forever.
            if (authState is Unauthenticated) return const SizedBox.shrink();
            if (authState is! Authenticated) return const LoadingView();
            final user = authState.session.user;
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              children: [
                // The identity header doubles as the "edit profile" entry —
                // tapping it opens the editor (a familiar pattern), so there is
                // no separate "Edit" row cluttering the account group.
                _ProfileHeader(
                  user: user,
                  onEdit: () => _openEditor(context, user),
                ),
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(l.profile_section_settings),
                const CardGroup(
                  rows: [_LanguageRow(), _ThemeRow(), _AppIconRow()],
                ),
                const SizedBox(height: AppSpacing.xl),
                CardGroup(
                  rows: [
                    AppTile(
                      icon: Icons.logout,
                      title: l.profile_logout,
                      destructive: true,
                      showChevron: false,
                      onTap: () => unawaited(_logout(context)),
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

/// Identity header, shown as a tappable card: a large avatar with the user's
/// initial, the full name, phone/address when present, and a trailing edit
/// affordance. Tapping anywhere opens the profile editor.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.onEdit});

  final User user;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fullName = [user.name, user.surname]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join(' ');
    final details = <String>[
      if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
        user.phoneNumber!,
      if (user.address != null && user.address!.isNotEmpty) user.address!,
    ];
    return Semantics(
      button: true,
      label: '${fullName.isEmpty ? '—' : fullName}. ${l.profile_edit}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: scheme.primaryContainer,
                  foregroundColor: scheme.onPrimaryContainer,
                  child: Text(
                    _initial(fullName),
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName.isEmpty ? '—' : fullName,
                        style: theme.textTheme.titleLarge,
                      ),
                      for (final line in details) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          line,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.edit_outlined, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _initial(String name) =>
      name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
}

/// Language row: shows the active language and opens a picker on tap.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final isRu = locale.languageCode == 'ru';
        return AppTile(
          icon: Icons.language_outlined,
          title: l.profile_language,
          value: isRu ? l.language_russian : l.language_kyrgyz,
          onTap: () => unawaited(_pick(context, isRu)),
        );
      },
    );
  }

  Future<void> _pick(BuildContext context, bool isRu) async {
    final l = AppLocalizations.of(context);
    final cubit = context.read<LocaleCubit>();
    final choice = await _showChoicePicker<String>(
      context: context,
      title: l.profile_language,
      selected: isRu ? 'ru' : 'ky',
      options: [
        (value: 'ky', label: l.language_kyrgyz, icon: Icons.translate),
        (value: 'ru', label: l.language_russian, icon: Icons.translate),
      ],
    );
    if (choice == 'ru') {
      cubit.setRussian();
    } else if (choice == 'ky') {
      cubit.setKyrgyz();
    }
  }
}

/// Theme row: shows the active theme mode and opens a picker on tap.
class _ThemeRow extends StatelessWidget {
  const _ThemeRow();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return AppTile(
          icon: Icons.brightness_6_outlined,
          title: l.profile_theme,
          value: _label(l, mode),
          onTap: () => unawaited(_pick(context, mode)),
        );
      },
    );
  }

  Future<void> _pick(BuildContext context, ThemeMode mode) async {
    final l = AppLocalizations.of(context);
    final cubit = context.read<ThemeCubit>();
    final choice = await _showChoicePicker<ThemeMode>(
      context: context,
      title: l.profile_theme,
      selected: mode,
      options: [
        (
          value: ThemeMode.light,
          label: l.theme_light,
          icon: Icons.light_mode_outlined,
        ),
        (
          value: ThemeMode.dark,
          label: l.theme_dark,
          icon: Icons.dark_mode_outlined,
        ),
        (
          value: ThemeMode.system,
          label: l.theme_system,
          icon: Icons.brightness_auto_outlined,
        ),
      ],
    );
    if (choice != null) cubit.setMode(choice);
  }

  String _label(AppLocalizations l, ThemeMode mode) => switch (mode) {
    ThemeMode.light => l.theme_light,
    ThemeMode.dark => l.theme_dark,
    ThemeMode.system => l.theme_system,
  };
}

/// App-icon row: shows the active launcher icon and opens the icon picker — the
/// disguise feature that lets the app hide as an everyday utility (calculator,
/// clock, …) on the home screen.
class _AppIconRow extends StatelessWidget {
  const _AppIconRow();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocBuilder<AppIconCubit, AppIcon>(
      builder: (context, icon) {
        return AppTile(
          icon: Icons.apps_outlined,
          title: l.profile_app_icon,
          value: appIconLabel(l, icon),
          onTap: () => unawaited(showAppIconSheet(context)),
        );
      },
    );
  }
}

/// A calm bottom-sheet chooser: a titled list where the current value carries a
/// check mark. Returns the chosen value, or null if dismissed. One tap picks
/// and closes — no confirm step.
Future<T?> _showChoicePicker<T>({
  required BuildContext context,
  required String title,
  required T selected,
  required List<({T value, String label, IconData icon})> options,
}) {
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xs,
                AppSpacing.xl,
                AppSpacing.sm,
              ),
              child: Text(title, style: theme.textTheme.titleMedium),
            ),
            for (final o in options)
              ListTile(
                leading: Icon(
                  o.icon,
                  color: o.value == selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                title: Text(o.label),
                trailing: o.value == selected
                    ? Icon(Icons.check, color: theme.colorScheme.primary)
                    : null,
                onTap: () => Navigator.of(ctx).pop(o.value),
              ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      );
    },
  );
}
