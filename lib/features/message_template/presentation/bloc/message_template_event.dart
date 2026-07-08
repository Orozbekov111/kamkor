part of 'message_template_bloc.dart';

sealed class MessageTemplateEvent extends Equatable {
  const MessageTemplateEvent();

  @override
  List<Object?> get props => [];
}

class MessageTemplateRequested extends MessageTemplateEvent {
  const MessageTemplateRequested();
}

class MessageTemplateSaved extends MessageTemplateEvent {
  const MessageTemplateSaved({
    required this.messageText,
    required this.geoSignature,
  });

  final String messageText;
  final String geoSignature;

  @override
  List<Object?> get props => [messageText, geoSignature];
}
