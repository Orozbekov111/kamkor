import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/router/app_router.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/utils/launcher.dart';
import 'package:kamkor/core/widgets/card_group.dart';
import 'package:kamkor/core/widgets/state_views/empty_view.dart';
import 'package:kamkor/core/widgets/state_views/error_view.dart';
import 'package:kamkor/core/widgets/state_views/loading_view.dart';
import 'package:kamkor/features/sos_history/domain/entities/sos_history_item.dart';
import 'package:kamkor/features/sos_history/presentation/bloc/sos_history_bloc.dart';
import 'package:kamkor/features/sos_history/presentation/sos_history_formatting.dart';

class SosHistoryView extends StatelessWidget {
  const SosHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.sos_history_title)),
      body: BlocBuilder<SosHistoryBloc, SosHistoryState>(
        builder: (context, state) {
          return switch (state.status) {
            SosHistoryStatus.initial ||
            SosHistoryStatus.loading =>
              const LoadingView(),
            SosHistoryStatus.failure => ErrorView(
                message: sosHistoryErrorText(l, state.error),
                retryLabel: l.retry,
                onRetry: () => context
                    .read<SosHistoryBloc>()
                    .add(const SosHistoryRequested()),
              ),
            SosHistoryStatus.ready => state.items.isEmpty
                ? EmptyView(
                    icon: Icons.history,
                    message: l.sos_history_empty_message,
                  )
                : _HistoryList(items: state.items),
          };
        },
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.items});

  final List<SosHistoryItem> items;

  Future<void> _openMap(
    BuildContext context,
    ({double lat, double lng}) coords,
  ) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await Launcher.openMap(coords.lat, coords.lng);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l.error_unknown)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    // Grouped-card list — the same container Profile, Info and Contacts use, so
    // every list in the app reads as one system.
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
              _historyRow(context, l, scheme, item),
          ],
        ),
      ],
    );
  }

  Widget _historyRow(
    BuildContext context,
    AppLocalizations l,
    ColorScheme scheme,
    SosHistoryItem item,
  ) {
    final coords = parseGeo(item.geo);
    return AppTile(
      icon: Icons.emergency_share_outlined,
      title: formatSosTimestamp(l, item.createdAt),
      subtitle: item.geo ?? l.sos_history_no_location,
      // A direct "open on map" shortcut when coordinates exist, so the user
      // reaches 2GIS/Google Maps in one tap without opening the detail page.
      trailing: coords == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.map_outlined, color: scheme.primary),
                  tooltip: l.sos_history_open_map,
                  onPressed: () => unawaited(_openMap(context, coords)),
                ),
                Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
              ],
            ),
      onTap: () => unawaited(
        context.router.push(SosHistoryDetailRoute(id: item.id)),
      ),
    );
  }
}
