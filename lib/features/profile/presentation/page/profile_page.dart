import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/di/injection.dart';
import 'package:kamkor/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:kamkor/features/profile/presentation/view/profile_view.dart';

/// Profile route entry — provides [ProfileBloc]. The displayed user comes from
/// the global auth session (the single source of user data).
@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>(),
      child: const ProfileView(),
    );
  }
}
