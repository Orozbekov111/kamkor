import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/message_template/domain/entities/message_template.dart';
import 'package:kamkor/features/message_template/domain/repositories/message_template_repository.dart';

class GetMessageTemplate {
  const GetMessageTemplate(this._repository);

  final MessageTemplateRepository _repository;

  ResultFuture<MessageTemplate> call() => _repository.getTemplate();
}
