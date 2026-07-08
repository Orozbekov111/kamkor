import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/utils/launcher.dart';
import 'package:kamkor/core/widgets/card_group.dart';
import 'package:kamkor/core/widgets/state_views/empty_view.dart';
import 'package:kamkor/core/widgets/state_views/error_view.dart';
import 'package:kamkor/core/widgets/state_views/loading_view.dart';
import 'package:kamkor/features/sos_history/domain/entities/sos_history_item.dart';
import 'package:kamkor/features/sos_history/presentation/bloc/sos_history_bloc.dart';
import 'package:kamkor/features/sos_history/presentation/bloc/sos_history_detail_bloc.dart';
import 'package:kamkor/features/sos_history/presentation/sos_history_formatting.dart';

class SosHistoryDetailView extends StatelessWidget {
  const SosHistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.sos_history_detail_title)),
      body: BlocBuilder<SosHistoryDetailBloc, SosHistoryDetailState>(
        builder: (context, state) {
          return switch (state.status) {
            SosHistoryStatus.initial ||
            SosHistoryStatus.loading =>
              const LoadingView(),
            SosHistoryStatus.failure => ErrorView(
                message: sosHistoryErrorText(l, state.error),
                retryLabel: l.retry,
                onRetry: () => _reload(context),
              ),
            // `ready` without an item shouldn't happen, but degrade gracefully
            // instead of force-unwrapping.
            SosHistoryStatus.ready => state.item == null
                ? EmptyView(
                    icon: Icons.history,
                    message: l.sos_history_empty_message,
                  )
                : _DetailBody(item: state.item!),
          };
        },
      ),
    );
  }

  void _reload(BuildContext context) {
    final state = context.read<SosHistoryDetailBloc>().state;
    final id = state.item?.id;
    if (id != null) {
      context.read<SosHistoryDetailBloc>().add(SosHistoryDetailRequested(id));
    }
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.item});

  final SosHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      // One grouped card of record fields — the same language as Profile and
      // the reference menus, so a history record reads like a calm document.
      children: [
        CardGroup(
          rows: [
            AppDetailTile(
              icon: Icons.tag,
              label: l.sos_history_id_label,
              value: '#${item.id}',
            ),
            AppDetailTile(
              icon: Icons.schedule,
              label: l.sos_history_date_label,
              value: formatSosTimestamp(l, item.createdAt),
            ),
            AppDetailTile(
              icon: Icons.location_on_outlined,
              label: l.sos_history_location_label,
              value: item.geo ?? l.sos_history_no_location,
              footer: item.geo == null
                  ? null
                  : _LocationActions(geo: item.geo!),
            ),
          ],
        ),
      ],
    );
  }
}

/// Copy / open-in-map actions for a recorded `"lat, lng"` geolocation.
class _LocationActions extends StatelessWidget {
  const _LocationActions({required this.geo});

  final String geo;

  Future<void> _copy(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: geo));
    messenger.showSnackBar(
      SnackBar(content: Text(l.sos_history_location_copied)),
    );
  }

  Future<void> _openMap(BuildContext context, double lat, double lng) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await Launcher.openMap(lat, lng);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l.error_unknown)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final coords = parseGeo(geo);
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        TextButton.icon(
          onPressed: () => unawaited(_copy(context)),
          icon: const Icon(Icons.copy, size: 18),
          label: Text(l.sos_history_copy_location),
        ),
        if (coords != null)
          TextButton.icon(
            onPressed: () =>
                unawaited(_openMap(context, coords.lat, coords.lng)),
            icon: const Icon(Icons.map_outlined, size: 18),
            label: Text(l.sos_history_open_map),
          ),
      ],
    );
  }
}
