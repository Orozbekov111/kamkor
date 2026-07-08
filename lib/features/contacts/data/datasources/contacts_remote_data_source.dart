import 'package:dio/dio.dart';
import 'package:kamkor/core/network/api_result.dart';
import 'package:kamkor/features/contacts/data/models/contact_model.dart';
import 'package:retrofit/retrofit.dart';

part 'contacts_remote_data_source.g.dart';

/// Raw Retrofit HTTP client for the trusted-contacts endpoints.
@RestApi()
abstract class ContactsApiClient {
  factory ContactsApiClient(Dio dio) = _ContactsApiClient;

  @GET('/api/my-contacts')
  Future<List<ContactModel>> getContacts();

  @POST('/api/my-contacts')
  Future<ContactModel> addContact(@Body() Map<String, dynamic> body);

  @PATCH('/api/my-contacts/{id}')
  Future<ContactModel> updateContact(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/api/my-contacts/{id}')
  Future<void> deleteContact(@Path('id') int id);
}

/// Wraps [ContactsApiClient] so only mapped `AppException`s reach the
/// repository.
class ContactsRemoteDataSource {
  ContactsRemoteDataSource(this._client);

  final ContactsApiClient _client;

  Future<List<ContactModel>> getContacts() =>
      safeApiCall(_client.getContacts);

  Future<ContactModel> addContact({
    required String name,
    required String phoneNumber,
  }) =>
      safeApiCall(
        () => _client.addContact({'name': name, 'phone_number': phoneNumber}),
      );

  Future<ContactModel> updateContact({
    required int id,
    String? name,
    String? phoneNumber,
  }) =>
      safeApiCall(
        () => _client.updateContact(id, {
          'name': ?name,
          'phone_number': ?phoneNumber,
        }),
      );

  Future<void> deleteContact(int id) =>
      safeApiCall(() => _client.deleteContact(id));
}
