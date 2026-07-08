import 'package:dio/dio.dart';
import 'package:kamkor/core/network/api_result.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_remote_data_source.g.dart';

/// Raw Retrofit HTTP client for the profile-update endpoint.
@RestApi()
// Retrofit needs an abstract client; only `update` lives here since reading
// the user reuses auth's `me`.
// ignore: one_member_abstracts
abstract class ProfileApiClient {
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @PUT('/api/user/update')
  Future<void> updateProfile(@Body() Map<String, dynamic> body);
}

/// Wraps [ProfileApiClient] so only mapped `AppException`s reach the
/// repository.
class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._client);

  final ProfileApiClient _client;

  Future<void> updateProfile({
    String? name,
    String? surname,
    String? phoneNumber,
    String? address,
    String? icon,
  }) =>
      safeApiCall(
        () => _client.updateProfile({
          'name': ?name,
          'surname': ?surname,
          'phone_number': ?phoneNumber,
          'address': ?address,
          'icon': ?icon,
        }),
      );
}
