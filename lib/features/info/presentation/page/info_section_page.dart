import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/di/injection.dart';
import 'package:kamkor/features/info/domain/entities/info_section.dart';
import 'package:kamkor/features/info/presentation/bloc/info_bloc.dart';
import 'package:kamkor/features/info/presentation/view/info_section_view.dart';

/// Article list for a single reference [section]. Reachable without auth.
@RoutePage()
class InfoSectionPage extends StatelessWidget {
  const InfoSectionPage({required this.section, super.key});

  final InfoSection section;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InfoBloc>()..add(InfoSectionRequested(section)),
      child: InfoSectionView(section: section),
    );
  }
}
