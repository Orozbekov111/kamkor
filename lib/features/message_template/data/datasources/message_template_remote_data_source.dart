import 'package:dio/dio.dart';
import 'package:kamkor/core/network/api_result.dart';
import 'package:kamkor/features/message_template/data/models/message_template_model.dart';
import 'package:retrofit/retrofit.dart';

part 'message_template_remote_data_source.g.dart';

/// Raw Retrofit HTTP client for the SOS message-template endpoints.
@RestApi()
abstract class MessageTemplateApiClient {
  factory MessageTemplateApiClient(Dio dio) = _MessageTemplateApiClient;

  // GET auto-creates a default template server-side on first access.
  @GET('/api/message-template')
  Future<MessageTemplateModel> getTemplate();

  @PUT('/api/message-template')
  Future<void> updateTemplate(@Body() Map<String, dynamic> body);
}

/// Wraps [MessageTemplateApiClient] so only mapped `AppException`s reach the
/// repository.
class MessageTemplateRemoteDataSource {
  MessageTemplateRemoteDataSource(this._client);

  final MessageTemplateApiClient _client;

  Future<MessageTemplateModel> getTemplate() =>
      safeApiCall(_client.getTemplate);

  Future<void> updateTemplate({
    required String messageText,
    required String geoSignature,
  }) =>
      safeApiCall(
        () => _client.updateTemplate({
          'message_text': messageText,
          'geo_signature': geoSignature,
        }),
      );
}
