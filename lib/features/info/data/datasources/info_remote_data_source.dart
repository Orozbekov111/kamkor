import 'package:dio/dio.dart';
import 'package:kamkor/core/network/api_result.dart';
import 'package:kamkor/features/info/data/models/info_item_model.dart';
import 'package:retrofit/retrofit.dart';

part 'info_remote_data_source.g.dart';

/// Raw Retrofit HTTP client for the public reference endpoints (no token).
/// Privacy policy is a POST by backend contract; the rest are GET.
@RestApi()
abstract class InfoApiClient {
  factory InfoApiClient(Dio dio) = _InfoApiClient;

  @GET('/api/crisis-centers')
  Future<List<InfoItemModel>> crisisCenters();

  @GET('/api/psychological-help')
  Future<List<InfoItemModel>> psychologicalHelp();

  @GET('/api/emergency-instructions')
  Future<List<InfoItemModel>> emergencyInstructions();

  @POST('/api/privacy-policy')
  Future<List<InfoItemModel>> privacyPolicy();
}

/// Wraps [InfoApiClient] so only mapped `AppException`s reach the repository.
class InfoRemoteDataSource {
  InfoRemoteDataSource(this._client);

  final InfoApiClient _client;

  Future<List<InfoItemModel>> crisisCenters() =>
      safeApiCall(_client.crisisCenters);

  Future<List<InfoItemModel>> psychologicalHelp() =>
      safeApiCall(_client.psychologicalHelp);

  Future<List<InfoItemModel>> emergencyInstructions() =>
      safeApiCall(_client.emergencyInstructions);

  Future<List<InfoItemModel>> privacyPolicy() =>
      safeApiCall(_client.privacyPolicy);
}
