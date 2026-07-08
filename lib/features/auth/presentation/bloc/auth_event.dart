part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Checks for an existing session on startup.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Sets the session right after a successful login (no extra network call).
class AuthLoggedIn extends AuthEvent {
  const AuthLoggedIn(this.session);

  final Session session;

  @override
  List<Object?> get props => [session];
}

class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();
}
