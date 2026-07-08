import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/di/injection.dart';
import 'package:kamkor/features/message_template/presentation/bloc/message_template_bloc.dart';
import 'package:kamkor/features/message_template/presentation/view/message_template_view.dart';

/// SOS message-template route entry — provides the bloc and loads the template.
@RoutePage()
class MessageTemplatePage extends StatelessWidget {
  const MessageTemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<MessageTemplateBloc>()..add(const MessageTemplateRequested()),
      child: const MessageTemplateView(),
    );
  }
}
