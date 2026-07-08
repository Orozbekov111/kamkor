part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Raw QR value or pasted link/token from the first phase.
class AccessTokenSubmitted extends LoginEvent {
  const AccessTokenSubmitted(this.input);

  final String input;

  @override
  List<Object?> get props => [input];
}

class PinSubmitted extends LoginEvent {
  const PinSubmitted(this.pin);

  final String pin;

  @override
  List<Object?> get props => [pin];
}

/// Returns to the link phase (e.g. wrong link scanned).
class LoginRestarted extends LoginEvent {
  const LoginRestarted();
}
