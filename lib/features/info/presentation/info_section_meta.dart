import 'package:flutter/material.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/features/info/domain/entities/info_section.dart';
import 'package:kamkor/features/info/presentation/bloc/info_bloc.dart';

/// Localized title for a reference section.
String infoSectionTitle(AppLocalizations l, InfoSection section) =>
    switch (section) {
      InfoSection.crisisCenters => l.info_crisis_centers,
      InfoSection.psychologicalHelp => l.info_psychological_help,
      InfoSection.emergencyInstructions => l.info_emergency_instructions,
      InfoSection.privacyPolicy => l.info_privacy_policy,
    };

/// A short one-line description shown under each section on the menu.
String infoSectionSubtitle(AppLocalizations l, InfoSection section) =>
    switch (section) {
      InfoSection.crisisCenters => l.info_crisis_centers_subtitle,
      InfoSection.psychologicalHelp => l.info_psychological_help_subtitle,
      InfoSection.emergencyInstructions =>
        l.info_emergency_instructions_subtitle,
      InfoSection.privacyPolicy => l.info_privacy_policy_subtitle,
    };

IconData infoSectionIcon(InfoSection section) => switch (section) {
      InfoSection.crisisCenters => Icons.local_hospital_outlined,
      InfoSection.psychologicalHelp => Icons.psychology_outlined,
      InfoSection.emergencyInstructions => Icons.menu_book_outlined,
      InfoSection.privacyPolicy => Icons.privacy_tip_outlined,
    };

String infoErrorText(AppLocalizations l, InfoError error) => switch (error) {
      InfoError.network => l.error_network,
      InfoError.timeout => l.error_timeout,
      InfoError.server => l.error_server,
      InfoError.unknown => l.error_unknown,
    };
