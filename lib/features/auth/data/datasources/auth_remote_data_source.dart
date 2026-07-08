import 'package:dio/dio.dart';
import 'package:kamkor/core/error/exceptions.dart';
import 'package:kamkor/core/network/api_result.dart';
import 'package:kamkor/features/auth/data/models/auth_token_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_data_source.g.dart';

/// Raw Retrofit HTTP client for auth endpoints.
@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST('/api/user/access-link/validate')
  Future<void> validate(@Body() Map<String, dynamic> body);

  @POST('/api/user/access-link/auth')
  Future<AuthTokenModel> auth(@Body() Map<String, dynamic> body);

  @GET('/api/user/me')
  Future<AuthTokenModel> me();

  @POST('/api/user/logout')
  Future<void> logout();
}

/// Wraps [AuthApiClient] so only [AppException]s escape to the repository.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final AuthApiClient _client;

  /// A 404 means the token is unknown, i.e. the link is not valid.
  Future<bool> validateAccessLink(String token) async {
    try {
      await safeApiCall(() => _client.validate({'access_token': token}));
      return true;
    } on ServerException catch (e) {
      if (e.httpCode == 404) return false;
      rethrow;
    }
  }

  Future<AuthTokenModel> login({
    required String token,
    required String pin,
    required String device,
  }) =>
      safeApiCall(
        () => _client.auth({
          'access_token': token,
          'pin': pin,
          'device': device,
        }),
      );

  Future<AuthTokenModel> getMe() => safeApiCall(_client.me);

  Future<void> logout() => safeApiCall(_client.logout);
}
