import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/message_template/domain/repositories/message_template_repository.dart';

class UpdateMessageTemplate {
  const UpdateMessageTemplate(this._repository);

  final MessageTemplateRepository _repository;

  ResultVoid call({
    required String messageText,
    required String geoSignature,
  }) =>
      _repository.updateTemplate(
        messageText: messageText,
        geoSignature: geoSignature,
      );
}
