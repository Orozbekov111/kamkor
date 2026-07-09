import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/app/app.dart';
import 'package:kamkor/core/app_icon/app_icon_cubit.dart';
import 'package:kamkor/core/di/injection.dart';
import 'package:kamkor/core/localization/locale_cubit.dart';
import 'package:kamkor/core/theme/theme_cubit.dart';
import 'package:kamkor/features/auth/presentation/bloc/auth_bloc.dart';

/// Top-level widget: provides app-wide blocs/cubits around [App].
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<LocaleCubit>()),
        BlocProvider.value(value: sl<ThemeCubit>()),
        BlocProvider.value(value: sl<AppIconCubit>()),
        // Kick off the session check that drives the initial route.
        BlocProvider.value(
          value: sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
      ],
      child: const App(),
    );
  }
}
