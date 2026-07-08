part of 'login_bloc.dart';

enum LoginPhase { enterLink, enterPin }

enum LoginStatus { idle, loading, success }

enum LoginError {
  none,
  linkRequired,
  linkInvalid,
  network,
  timeout,
  server,
  wrongPin,
  unknown,
}

class LoginState extends Equatable {
  const LoginState({
    this.phase = LoginPhase.enterLink,
    this.status = LoginStatus.idle,
    this.accessToken,
    this.error = LoginError.none,
    this.session,
  });

  final LoginPhase phase;
  final LoginStatus status;
  final String? accessToken;
  final LoginError error;
  final Session? session;

  bool get isLoading => status == LoginStatus.loading;

  LoginState copyWith({
    LoginPhase? phase,
    LoginStatus? status,
    String? accessToken,
    LoginError? error,
    Session? session,
  }) =>
      LoginState(
        phase: phase ?? this.phase,
        status: status ?? this.status,
        accessToken: accessToken ?? this.accessToken,
        error: error ?? this.error,
        session: session ?? this.session,
      );

  @override
  List<Object?> get props => [phase, status, accessToken, error, session];
}
