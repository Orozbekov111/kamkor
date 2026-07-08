import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/router/app_router.dart';
import 'package:kamkor/core/theme/app_motion.dart';
import 'package:kamkor/core/theme/app_semantic_colors.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/widgets/state_views/error_view.dart';
import 'package:kamkor/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:kamkor/features/info/domain/entities/info_section.dart';
import 'package:kamkor/features/info/presentation/info_section_meta.dart';
import 'package:kamkor/features/sos/presentation/bloc/sos_bloc.dart';
import 'package:kamkor/features/sos/presentation/widgets/sos_active_view.dart';
import 'package:kamkor/features/sos/presentation/widgets/sos_button.dart';
import 'package:kamkor/features/sos/presentation/widgets/sos_closed_view.dart';
import 'package:kamkor/features/sos/presentation/widgets/sos_permission_view.dart';

class SosView extends StatefulWidget {
  const SosView({super.key});

  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView>
    with AutoRouteAwareStateMixin<SosView> {
  @override
  void didChangeTabRoute(TabPageRoute previousRoute) {
    // Returned to the SOS tab — re-fetch so the readiness hint reflects edits
    // made on the Contacts tab (a separate bloc instance). Offline-safe: the
    // indicator keeps its last known state until this resolves and never flips
    // to a false "ready".
    if (!mounted) return;
    context.read<ContactsBloc>().add(const ContactsRequested());
  }

  @override
  Widget build(BuildContext context) {
    // No Scaffold here — the host `HomePage` owns it, so a single
    // ScaffoldMessenger handles SnackBars for this subtree.
    return BlocBuilder<SosBloc, SosState>(
      builder: (context, state) => AnimatedSwitcher(
        duration: AppMotion.resolve(context, AppMotion.medium),
        child: _buildForState(context, state),
      ),
    );
  }

  Widget _buildForState(BuildContext context, SosState state) {
    final bloc = context.read<SosBloc>();
    return switch (state) {
      SosIdle() => const _IdleView(key: ValueKey('idle')),
      SosFailure() => _FailureView(
          key: const ValueKey('failure'),
          error: state.error,
        ),
      SosActivating() => _ActivatingView(
          key: const ValueKey('activating'),
          attempt: state.attempt,
        ),
      SosPermissionRequired() => SosPermissionView(
          key: const ValueKey('permission'),
          reason: state.reason,
          onAllow: () => bloc.add(const SosTriggered()),
          onOpenAppSettings: () => bloc.add(const SosAppSettingsRequested()),
          onOpenLocationSettings: () =>
              bloc.add(const SosLocationServiceRequested()),
        ),
      SosActive() => SosActiveView(
          key: const ValueKey('active'),
          state: state,
        ),
      SosClosed() => SosClosedView(
          key: const ValueKey('closed'),
          reason: state.reason,
          onDone: () => bloc.add(const SosDismissed()),
        ),
    };
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Fill the viewport and split it: the title + SOS button sit in the upper
    // centre (in the thumb zone), while readiness and the quick links stay
    // pinned to the bottom — a stable, predictable layout at any screen height
    // that still scrolls when space is tight (e.g. large text / short screens).
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - AppSpacing.xl * 2,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      l.sos_idle_title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // The button owns the whole gesture: hold-to-arm, then an
                    // in-circle cancelable countdown before the alarm fires.
                    SosButton(
                      label: l.sos_button,
                      holdHint: l.sos_hold_hint,
                      countdownHint: l.sos_countdown_hint,
                      cancelLabel: l.sos_countdown_cancel,
                      onActivate: () =>
                          context.read<SosBloc>().add(const SosTriggered()),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // The SOS message-template entry, moved here from the app
                    // bar so it sits right under the button it configures.
                    TextButton.icon(
                      onPressed: () => unawaited(
                        context.router.push(const MessageTemplateRoute()),
                      ),
                      icon: const Icon(Icons.message_outlined),
                      label: Text(l.message_template_title),
                    ),
                    const Spacer(),
                    const SizedBox(height: AppSpacing.xxl),
                    const _QuickAccess(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Secondary, low-key access to the support-reference sections most useful in a
/// crisis (psychological help, crisis centres), plus a readiness hint so a user
/// notices before an emergency if their trusted contacts are empty.
class _QuickAccess extends StatelessWidget {
  const _QuickAccess();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ReadinessIndicator(),
        SizedBox(height: AppSpacing.md),
        _InfoSectionButton(section: InfoSection.psychologicalHelp),
        SizedBox(height: AppSpacing.sm),
        _InfoSectionButton(section: InfoSection.crisisCenters),
      ],
    );
  }
}

/// Opens a public reference section (pushed over the shell), using the same
/// icon and title as the Info menu so the entry reads consistently.
class _InfoSectionButton extends StatelessWidget {
  const _InfoSectionButton({required this.section});

  final InfoSection section;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return OutlinedButton.icon(
      onPressed: () =>
          unawaited(context.router.push(InfoSectionRoute(section: section))),
      icon: Icon(infoSectionIcon(section)),
      label: Text(infoSectionTitle(l, section)),
    );
  }
}

/// Reads the home-scoped [ContactsBloc]; stays silent until the list is known
/// so it never shows a misleading "not configured" while loading or offline.
class _ReadinessIndicator extends StatelessWidget {
  const _ReadinessIndicator();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        if (state.status != ContactsStatus.ready) {
          return const SizedBox.shrink();
        }
        final ready = state.contacts.isNotEmpty;
        // Empty is a calm "attention" hint (amber warning), not an alarm — red
        // stays reserved for SOS. Icon + text carry the meaning (not color
        // alone).
        final color =
            ready ? theme.colorScheme.primary : context.semantic.warning;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ready ? Icons.check_circle_outline : Icons.warning_amber_rounded,
              size: 18,
              color: color,
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                ready
                    ? l.sos_readiness_contacts_ready
                    : l.sos_readiness_contacts_empty,
                style: theme.textTheme.bodyMedium?.copyWith(color: color),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActivatingView extends StatelessWidget {
  const _ActivatingView({required this.attempt, super.key});

  /// Persistent-creation retry round (see [SosActivating.attempt]).
  final int attempt;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // 0: first try. 1..4: retrying — reassure it's still being sent. >4: the
    // network has been down a while — escalate so the user isn't left guessing.
    final text = switch (attempt) {
      0 => l.sos_activating,
      <= 4 => l.sos_activating_retry,
      _ => l.sos_activating_struggling,
    };
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.error, super.key});

  final SosActivationError error;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final message = switch (error) {
      SosActivationError.network => l.error_network,
      SosActivationError.timeout => l.error_timeout,
      SosActivationError.server => l.error_server,
      SosActivationError.locationUnavailable => l.error_location_unavailable,
      SosActivationError.unauthorized => l.error_unauthorized,
      SosActivationError.unknown => l.error_unknown,
    };
    return SafeArea(
      child: ErrorView(
        message: message,
        retryLabel: l.retry,
        onRetry: () => context.read<SosBloc>().add(const SosTriggered()),
      ),
    );
  }
}
