import 'package:flutter/material.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_semantic_colors.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/widgets/app_button.dart';
import 'package:kamkor/features/sos/presentation/bloc/sos_bloc.dart';

/// Explains why the alarm can't start and offers a single clear recovery
/// action tailored to the exact reason (service off / denied / denied forever).
class SosPermissionView extends StatelessWidget {
  const SosPermissionView({
    required this.reason,
    required this.onAllow,
    required this.onOpenAppSettings,
    required this.onOpenLocationSettings,
    super.key,
  });

  final SosPermissionReason reason;

  /// Re-run the preflight (re-requests a merely-denied permission).
  final VoidCallback onAllow;
  final VoidCallback onOpenAppSettings;
  final VoidCallback onOpenLocationSettings;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final (title, message, button, action) = switch (reason) {
      SosPermissionReason.serviceDisabled => (
          l.sos_service_disabled_title,
          l.sos_service_disabled,
          l.sos_enable_location,
          onOpenLocationSettings,
        ),
      SosPermissionReason.denied => (
          l.sos_permission_title,
          l.sos_permission_denied,
          l.sos_allow,
          onAllow,
        ),
      SosPermissionReason.deniedForever => (
          l.sos_permission_title,
          l.sos_permission_denied_forever,
          l.sos_open_settings,
          onOpenAppSettings,
        ),
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.location_off,
              size: 72,
              // Attention, not alarm — amber warning. Red is reserved for SOS.
              color: context.semantic.warning,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(label: button, onPressed: action),
          ],
        ),
      ),
    );
  }
}
