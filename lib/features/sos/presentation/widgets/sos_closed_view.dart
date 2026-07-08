import 'package:flutter/material.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/widgets/app_button.dart';
import 'package:kamkor/features/sos/presentation/bloc/sos_bloc.dart';

/// Shown after an operator closes the alarm; tracking has already stopped by
/// the time this renders.
class SosClosedView extends StatelessWidget {
  const SosClosedView({required this.reason, required this.onDone, super.key});

  final SosCloseReason reason;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final subtitle = switch (reason) {
      SosCloseReason.done => l.sos_closed_done,
      SosCloseReason.cancelled => l.sos_closed_cancelled,
      SosCloseReason.ended => l.sos_closed_subtitle,
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 88,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l.sos_closed_title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(label: l.sos_closed_action, onPressed: onDone),
          ],
        ),
      ),
    );
  }
}
