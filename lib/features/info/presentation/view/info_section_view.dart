import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/router/app_router.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/widgets/card_group.dart';
import 'package:kamkor/core/widgets/state_views/empty_view.dart';
import 'package:kamkor/core/widgets/state_views/error_view.dart';
import 'package:kamkor/core/widgets/state_views/loading_view.dart';
import 'package:kamkor/features/info/domain/entities/info_item.dart';
import 'package:kamkor/features/info/domain/entities/info_section.dart';
import 'package:kamkor/features/info/presentation/bloc/info_bloc.dart';
import 'package:kamkor/features/info/presentation/info_section_meta.dart';
import 'package:kamkor/features/info/presentation/widgets/emergency_contacts_list.dart';

class InfoSectionView extends StatelessWidget {
  const InfoSectionView({required this.section, super.key});

  final InfoSection section;

  /// The emergency section falls back to bundled numbers on a connectivity
  /// failure only — server/unknown errors still show the normal error view.
  bool _showOfflineEmergency(InfoError error) =>
      section == InfoSection.emergencyInstructions &&
      (error == InfoError.network || error == InfoError.timeout);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(infoSectionTitle(l, section))),
      body: BlocBuilder<InfoBloc, InfoState>(
        builder: (context, state) {
          return switch (state.status) {
            InfoStatus.initial || InfoStatus.loading => const LoadingView(),
            // Emergency numbers must survive a network drop: fall back to the
            // bundled list instead of a bare error. Online data stays primary.
            InfoStatus.failure => _showOfflineEmergency(state.error)
                ? EmergencyContactsList(notice: l.info_offline_notice)
                : ErrorView(
                    message: infoErrorText(l, state.error),
                    retryLabel: l.retry,
                    onRetry: () => context
                        .read<InfoBloc>()
                        .add(InfoSectionRequested(section)),
                  ),
            InfoStatus.ready => state.items.isEmpty
                ? EmptyView(
                    icon: Icons.article_outlined,
                    message: l.info_empty_message,
                  )
                : _ArticleList(items: state.items),
          };
        },
      ),
    );
  }
}

class _ArticleList extends StatelessWidget {
  const _ArticleList({required this.items});

  final List<InfoItem> items;

  @override
  Widget build(BuildContext context) {
    // Grouped-card list — the same container as the Info menu, Profile and the
    // other lists, so the whole app reads as one system.
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      children: [
        CardGroup(
          rows: [
            for (final item in items)
              AppTile(
                icon: Icons.article_outlined,
                title: item.title,
                onTap: () => unawaited(
                  context.router.push(
                    InfoDetailRoute(title: item.title, body: item.body),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
