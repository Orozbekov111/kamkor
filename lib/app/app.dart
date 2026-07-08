import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/di/injection.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/localization/locale_cubit.dart';
import 'package:kamkor/core/router/app_router.dart';
import 'package:kamkor/core/theme/app_theme.dart';
import 'package:kamkor/core/theme/theme_cubit.dart';
import 'package:kamkor/features/auth/presentation/bloc/auth_bloc.dart';

/// Root MaterialApp: router, theme, reactive localization and the auth gate.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = sl<AppRouter>();
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          curr is Authenticated || curr is Unauthenticated,
      listener: (context, state) {
        if (state is Authenticated) {
          unawaited(router.replaceAll([const HomeRoute()]));
        } else if (state is Unauthenticated) {
          unawaited(router.replaceAll([const LoginRoute()]));
        }
      },
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context).appName,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                // User choice from ThemeCubit (persisted); defaults to system.
                themeMode: themeMode,
                locale: locale,
                localizationsDelegates:
                    AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: router.config(),
                // Support system font scaling up to 200% (WCAG 1.4.4) while
                // clamping beyond that so dense crisis screens stay usable.
                builder: (context, child) =>
                    MediaQuery.withClampedTextScaling(
                  minScaleFactor: 1,
                  maxScaleFactor: 2,
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
