import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/di/injection.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:kamkor/features/sos/presentation/bloc/sos_bloc.dart';
import 'package:kamkor/features/sos/presentation/view/sos_view.dart';

/// The SOS home tab — the alarm is the primary content of the app.
///
/// This tab owns its Scaffold/AppBar (the navigation shell provides only the
/// bottom bar). The SOS message template is reached from the app bar (reference
/// info now has its own bottom-nav tab). [SosBloc] is the app-wide singleton,
/// provided via `.value` so an active alarm survives switching tabs; a
/// [ContactsBloc] surfaces the trusted-contacts readiness hint on the idle
/// screen.
@RoutePage()
class SosPage extends StatelessWidget {
  const SosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      // The SOS message-template entry now lives under the SOS button on the
      // idle screen (see SosView), so the app bar stays a plain title.
      appBar: AppBar(title: Text(l.appName)),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<SosBloc>()),
          BlocProvider(
            create: (_) => sl<ContactsBloc>()..add(const ContactsRequested()),
          ),
        ],
        child: const SosView(),
      ),
    );
  }
}
