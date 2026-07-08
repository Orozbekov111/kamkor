import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/di/injection.dart';
import 'package:kamkor/features/sos_history/presentation/bloc/sos_history_detail_bloc.dart';
import 'package:kamkor/features/sos_history/presentation/view/sos_history_detail_view.dart';

/// SOS-history detail route entry — loads the request identified by [id].
@RoutePage()
class SosHistoryDetailPage extends StatelessWidget {
  const SosHistoryDetailPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<SosHistoryDetailBloc>()..add(SosHistoryDetailRequested(id)),
      child: const SosHistoryDetailView(),
    );
  }
}
