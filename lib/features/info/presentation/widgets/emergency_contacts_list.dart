import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/utils/launcher.dart';
import 'package:kamkor/core/widgets/app_banner.dart';
import 'package:kamkor/core/widgets/card_group.dart';
import 'package:kamkor/features/info/emergency_contacts.dart';

/// Renders the bundled emergency numbers with a call action each. Shown as the
/// offline fallback when the emergency section can't be fetched.
class EmergencyContactsList extends StatelessWidget {
  const EmergencyContactsList({this.notice, super.key});

  /// Optional banner explaining why the local list is shown.
  final String? notice;

  Future<void> _call(BuildContext context, String number) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await Launcher.dial(number);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l.error_call_failed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      children: [
        // Offline fallback → an "attention" (amber) banner, not an error.
        if (notice != null) ...[
          AppBanner.attention(text: notice!),
          const SizedBox(height: AppSpacing.xl),
        ],
        CardGroup(
          rows: [
            for (final contact in kEmergencyContacts)
              AppTile(
                icon: Icons.emergency_outlined,
                title: emergencyServiceLabel(l, contact.service),
                subtitle: contact.number,
                // Same call affordance as the trusted-contacts list, so
                // "tap to call" reads identically across the app.
                trailing: IconButton(
                  icon: Icon(Icons.call, color: scheme.primary),
                  tooltip: l.emergency_call,
                  onPressed: () => unawaited(_call(context, contact.number)),
                ),
                onTap: () => unawaited(_call(context, contact.number)),
              ),
          ],
        ),
      ],
    );
  }
}
