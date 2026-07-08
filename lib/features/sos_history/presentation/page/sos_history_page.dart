import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/di/injection.dart';
import 'package:kamkor/features/sos_history/presentation/bloc/sos_history_bloc.dart';
import 'package:kamkor/features/sos_history/presentation/view/sos_history_view.dart';

/// SOS-history route entry — provides the bloc and loads the list.
@RoutePage()
class SosHistoryPage extends StatelessWidget {
  const SosHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SosHistoryBloc>()..add(const SosHistoryRequested()),
      child: const SosHistoryView(),
    );
  }
}
