import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/router/app_router.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/widgets/card_group.dart';
import 'package:kamkor/features/info/domain/entities/info_section.dart';
import 'package:kamkor/features/info/presentation/info_section_meta.dart';

/// Menu of the four public reference sections.
class InfoView extends StatelessWidget {
  const InfoView({super.key});

  /// Display order: the actionable emergency guidance is raised to the top and
  /// the privacy policy kept last.
  static const List<InfoSection> _order = [
    InfoSection.emergencyInstructions,
    InfoSection.crisisCenters,
    InfoSection.psychologicalHelp,
    InfoSection.privacyPolicy,
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.info_title)),
      // Fixed-length navigation menu → the grouped-card language shared with
      // Profile, so the whole app reads as one system.
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xxl,
        ),
        children: [
          CardGroup(
            rows: [
              for (final section in _order)
                AppTile(
                  icon: infoSectionIcon(section),
                  title: infoSectionTitle(l, section),
                  subtitle: infoSectionSubtitle(l, section),
                  onTap: () => unawaited(
                    context.router.push(InfoSectionRoute(section: section)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
