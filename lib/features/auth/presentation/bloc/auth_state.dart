part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  const Authenticated(this.session);

  final Session session;

  @override
  List<Object?> get props => [session];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}
