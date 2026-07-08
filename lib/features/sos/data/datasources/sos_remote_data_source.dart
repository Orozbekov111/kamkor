import 'package:dio/dio.dart';
import 'package:kamkor/core/error/exceptions.dart';
import 'package:kamkor/core/network/api_result.dart';
import 'package:kamkor/features/sos/data/mappers/sos_mappers.dart';
import 'package:kamkor/features/sos/data/models/sos_model.dart';
import 'package:kamkor/features/sos/domain/entities/geo_point.dart';
import 'package:retrofit/retrofit.dart';

part 'sos_remote_data_source.g.dart';

/// Raw Retrofit HTTP client for the SOS endpoints.
@RestApi()
abstract class SosApiClient {
  factory SosApiClient(Dio dio) = _SosApiClient;

  @POST('/api/sos')
  Future<SosModel> createSos(@Body() Map<String, dynamic> body);

  @POST('/api/sos/{id}/location')
  Future<void> updateLocation(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @GET('/api/sos/{id}')
  Future<SosModel> getSos(@Path('id') String id);
}

/// Wraps [SosApiClient] so only [AppException]s escape to the repository, and
/// a 409 on an active-alarm write surfaces as a distinct [SosClosedException].
class SosRemoteDataSource {
  SosRemoteDataSource(this._client);

  final SosApiClient _client;

  Future<SosModel> createSos(GeoPoint start) => safeApiCall(
        () => _client.createSos({'geolocation': formatGeolocation(start)}),
      );

  Future<void> updateLocation(String id, GeoPoint point) => _guardClosed(
        () => _client.updateLocation(id, point.toLocationModel().toJson()),
      );

  Future<SosModel> getSos(String id) => safeApiCall(() => _client.getSos(id));

  /// The backend returns 409 once an alarm is done/cancelled; the error
  /// interceptor maps it to a generic [ServerException], which we re-tag as
  /// [SosClosedException] so the repository can react specifically.
  Future<void> _guardClosed(Future<void> Function() call) async {
    try {
      await safeApiCall(call);
    } on ServerException catch (e) {
      if (e.httpCode == 409) throw const SosClosedException();
      rethrow;
    }
  }
}
