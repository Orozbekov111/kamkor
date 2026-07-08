import 'package:dio/dio.dart';
import 'package:kamkor/core/error/exceptions.dart';

/// Converts [DioException]s into typed [AppException]s carried in `error`.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: _map(err),
      ),
    );
  }

  AppException _map(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        return _mapResponse(err.response);
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return const UnknownException();
    }
  }

  AppException _mapResponse(Response<dynamic>? response) {
    final code = response?.statusCode ?? 0;
    return switch (code) {
      401 => const UnauthorizedException(),
      422 => _validation(response),
      >= 500 => ServerException('Ошибка сервера', httpCode: code),
      _ => ServerException('Ошибка запроса', httpCode: code),
    };
  }

  /// Parses a Laravel-style body: `{ message, errors: { field: [msg] } }`.
  ValidationException _validation(Response<dynamic>? response) {
    final data = response?.data;
    if (data is Map) {
      final message = data['message']?.toString() ?? 'Ошибка валидации';
      final raw = data['errors'];
      final errors = raw is Map
          ? raw.map(
              (key, value) => MapEntry(
                key.toString(),
                (value as List).map((e) => e.toString()).toList(),
              ),
            )
          : null;
      return ValidationException(message, errors: errors);
    }
    return const ValidationException('Ошибка валидации');
  }
}
