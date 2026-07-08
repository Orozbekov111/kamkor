import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_motion.dart';
import 'package:kamkor/core/theme/app_radius.dart';
import 'package:kamkor/core/theme/app_semantic_colors.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/features/sos/presentation/bloc/sos_bloc.dart';

/// Calm, unambiguous confirmation that help is on the way. No alarming visuals
/// and no controls the user cannot act on (only an operator closes an alarm).
///
/// Uses the dedicated `sosActive` green — a vivid tone distinct from the calm
/// brand green — plus a badge and slow pulse, so this state never reads as
/// ordinary UI. Structure and pulse are intentionally unchanged.
class SosActiveView extends StatelessWidget {
  const SosActiveView({required this.state, super.key});

  final SosActive state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final semantic = context.semantic;
    final reconnecting = state.connection == SosConnection.reconnecting;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (reconnecting) _ReconnectingBanner(label: l.sos_reconnecting),
            const Spacer(),
            Center(child: _ActiveBadge(label: l.sos_active_badge)),
            const SizedBox(height: AppSpacing.xl),
            const Center(child: _PulsingShield()),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l.sos_active_title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: semantic.sosActive,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.sos_active_subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            _StatusTile(
              icon: Icons.my_location,
              title: l.sos_coords_transmitting,
              subtitle: _lastSentLabel(context, l),
              active: !reconnecting,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  String _lastSentLabel(BuildContext context, AppLocalizations l) {
    final sentAt = state.lastSentAt;
    if (sentAt == null) return l.sos_awaiting_signal;
    final time = DateFormat.Hms().format(sentAt);
    return l.sos_last_sent(time);
  }
}

/// Explicit "alarm is active" label — icon + text, so the state is legible
/// without relying on color alone (WCAG 1.4.1).
class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semantic;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: semantic.sosActiveContainer,
        borderRadius: AppRadius.brLg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield,
            size: 18,
            color: semantic.onSosActiveContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: semantic.onSosActiveContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReconnectingBanner extends StatelessWidget {
  const _ReconnectingBanner({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.icon,
    required this.title,
    required this.active,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = active
        ? context.semantic.sosActive
        : theme.colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A slow, steady pulse — reassuring, not alarming. Honors reduce-motion:
/// when animations are disabled the shield holds a steady tone instead.
class _PulsingShield extends StatefulWidget {
  const _PulsingShield();

  @override
  State<_PulsingShield> createState() => _PulsingShieldState();
}

class _PulsingShieldState extends State<_PulsingShield>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.pulse,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reduce-motion: stop at a steady tone; otherwise keep the slow pulse.
    if (AppMotion.reduceMotion(context)) {
      if (_controller.isAnimating) _controller.stop();
      _controller.value = 1;
    } else if (!_controller.isAnimating) {
      unawaited(_controller.repeat(reverse: true));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final semantic = context.semantic;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: semantic.sosActive.withValues(alpha: 0.08 + t * 0.08),
          ),
          child: Center(
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: semantic.sosActive,
              ),
              child: Icon(
                Icons.verified_user,
                color: semantic.onSosActive,
                size: 56,
              ),
            ),
          ),
        );
      },
    );
  }
}
