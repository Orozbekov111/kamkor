import 'package:dartz/dartz.dart';
import 'package:kamkor/core/error/exceptions.dart';
import 'package:kamkor/core/error/failure_mapper.dart';
import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/message_template/data/datasources/message_template_remote_data_source.dart';
import 'package:kamkor/features/message_template/data/mappers/message_template_mappers.dart';
import 'package:kamkor/features/message_template/domain/entities/message_template.dart';
import 'package:kamkor/features/message_template/domain/repositories/message_template_repository.dart';

class MessageTemplateRepositoryImpl implements MessageTemplateRepository {
  MessageTemplateRepositoryImpl(this._remote);

  final MessageTemplateRemoteDataSource _remote;

  @override
  ResultFuture<MessageTemplate> getTemplate() async {
    try {
      final model = await _remote.getTemplate();
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  ResultVoid updateTemplate({
    required String messageText,
    required String geoSignature,
  }) async {
    try {
      await _remote.updateTemplate(
        messageText: messageText,
        geoSignature: geoSignature,
      );
      return const Right(null);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
