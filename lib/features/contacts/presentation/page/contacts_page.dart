import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/di/injection.dart';
import 'package:kamkor/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:kamkor/features/contacts/presentation/view/contacts_view.dart';

/// Trusted-contacts route entry — provides [ContactsBloc] and loads the list.
@RoutePage()
class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ContactsBloc>()..add(const ContactsRequested()),
      child: const ContactsView(),
    );
  }
}
