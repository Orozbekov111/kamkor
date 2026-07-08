import 'package:kamkor/core/error/exceptions.dart';
import 'package:kamkor/core/error/failures.dart';

/// Maps a data-layer [AppException] to its domain [Failure] counterpart.
Failure mapExceptionToFailure(Object error) {
  return switch (error) {
    NetworkException() => NetworkFailure(error.message),
    TimeoutException() => TimeoutFailure(error.message),
    ServerException() => ServerFailure(error.message, httpCode: error.httpCode),
    UnauthorizedException() => UnauthorizedFailure(error.message),
    ValidationException() =>
      ValidationFailure(error.message, errors: error.errors),
    SosClosedException() => SosClosedFailure(error.message),
    UnknownException() => UnknownFailure(error.message),
    _ => const UnknownFailure('Неизвестная ошибка'),
  };
}
