/// Base type for all data-layer exceptions.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Нет подключения к сети']);
}

class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Превышено время ожидания']);
}

class ServerException extends AppException {
  const ServerException(super.message, {this.httpCode});

  final int? httpCode;
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Требуется авторизация']);
}

class ValidationException extends AppException {
  const ValidationException(super.message, {this.errors});

  /// Field name -> validation messages, as returned by the backend.
  final Map<String, List<String>>? errors;
}

class UnknownException extends AppException {
  const UnknownException([super.message = 'Неизвестная ошибка']);
}

/// A 409 on an SOS request: the alarm was closed (done/cancelled) by an
/// operator. The client must stop location tracking at once.
class SosClosedException extends AppException {
  const SosClosedException([super.message = 'Тревога завершена']);
}
