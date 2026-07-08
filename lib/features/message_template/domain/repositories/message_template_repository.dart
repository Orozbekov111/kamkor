import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/message_template/domain/entities/message_template.dart';

abstract interface class MessageTemplateRepository {
  /// Returns the template. The backend creates a default one on first read,
  /// so this never yields "empty".
  ResultFuture<MessageTemplate> getTemplate();

  ResultVoid updateTemplate({
    required String messageText,
    required String geoSignature,
  });
}
