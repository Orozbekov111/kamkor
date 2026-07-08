import 'package:equatable/equatable.dart';

/// Base type for all domain-layer failures.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.httpCode});

  final int? httpCode;

  @override
  List<Object?> get props => [message, httpCode];
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.errors});

  final Map<String, List<String>>? errors;

  @override
  List<Object?> get props => [message, errors];
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

/// Domain counterpart of `SosClosedException`: the active alarm is closed.
/// The SOS bloc treats this distinctly — it halts tracking rather
/// than surfacing a transient error.
class SosClosedFailure extends Failure {
  const SosClosedFailure([super.message = 'Тревога завершена']);
}
