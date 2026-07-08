import 'package:dio/dio.dart';
import 'package:kamkor/core/network/api_result.dart';
import 'package:kamkor/features/sos_history/data/models/sos_history_item_model.dart';
import 'package:retrofit/retrofit.dart';

part 'sos_history_remote_data_source.g.dart';

/// Raw Retrofit HTTP client for the SOS-history endpoints.
@RestApi()
abstract class SosHistoryApiClient {
  factory SosHistoryApiClient(Dio dio) = _SosHistoryApiClient;

  @GET('/api/sos')
  Future<SosHistoryListResponse> getHistory();

  @GET('/api/sos/{id}')
  Future<SosHistoryItemModel> getHistoryItem(@Path('id') int id);
}

/// Wraps [SosHistoryApiClient], unwrapping the `data` envelope and letting only
/// mapped `AppException`s reach the repository.
class SosHistoryRemoteDataSource {
  SosHistoryRemoteDataSource(this._client);

  final SosHistoryApiClient _client;

  Future<List<SosHistoryItemModel>> getHistory() async {
    final response = await safeApiCall(_client.getHistory);
    return response.data;
  }

  Future<SosHistoryItemModel> getHistoryItem(int id) =>
      safeApiCall(() => _client.getHistoryItem(id));
}
