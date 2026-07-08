import 'package:dio/dio.dart';
import 'package:kamkor/core/constants/api_endpoints.dart';
import 'package:kamkor/core/storage/secure_storage.dart';

/// Adds `Authorization: Bearer <token>` to protected requests.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final SecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isPublic(options.path)) {
      final token = await _storage.readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  bool _isPublic(String path) => ApiEndpoints.publicPaths.any(path.contains);
}
