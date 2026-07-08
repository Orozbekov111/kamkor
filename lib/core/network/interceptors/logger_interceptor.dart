import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs requests/responses in debug only, masking sensitive values.
class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('→ ${options.method} ${options.uri}');
      if (options.headers.containsKey('Authorization')) {
        debugPrint('  Authorization: Bearer ***');
      }
      if (options.data != null) {
        debugPrint('  body: ${_maskBody(options.data)}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint('← ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  String _maskBody(Object? data) {
    if (data is Map && data.containsKey('access_token')) {
      return {...data, 'access_token': '***'}.toString();
    }
    return data.toString();
  }
}
