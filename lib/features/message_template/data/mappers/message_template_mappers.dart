import 'package:kamkor/features/message_template/data/models/message_template_model.dart';
import 'package:kamkor/features/message_template/domain/entities/message_template.dart';

extension MessageTemplateModelMapper on MessageTemplateModel {
  MessageTemplate toEntity() => MessageTemplate(
        messageText: messageText,
        geoSignature: geoSignature,
      );
}
