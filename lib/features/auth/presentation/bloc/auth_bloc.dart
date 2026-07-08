import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kamkor/core/config/app_config.dart';
import 'package:kamkor/core/error/failures.dart';
import 'package:kamkor/features/auth/domain/entities/session.dart';
import 'package:kamkor/features/auth/domain/usecases/get_current_session.dart';
import 'package:kamkor/features/auth/domain/usecases/logout.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Global authentication status; the router reacts to its state.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetCurrentSession getCurrentSession,
    required Logout logout,
  })  : _getCurrentSession = getCurrentSession,
        _logout = logout,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoggedIn>(_onLoggedIn);
    on<AuthLoggedOut>(_onLoggedOut);
  }

  final GetCurrentSession _getCurrentSession;
  final Logout _logout;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    // Guarantee the splash resolves: on any failure or a stalled network the
    // check falls back to the login screen instead of hanging on "Проверка…".
    final result = await _getCurrentSession().timeout(
      AppConfig.sessionCheckTimeout,
      onTimeout: () => const Left(TimeoutFailure('session check timed out')),
    );
    result.fold(
      (_) => emit(const Unauthenticated()),
      (session) => emit(
        session == null ? const Unauthenticated() : Authenticated(session),
      ),
    );
  }

  void _onLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) =>
      emit(Authenticated(event.session));

  Future<void> _onLoggedOut(
    AuthLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    await _logout();
    emit(const Unauthenticated());
  }
}
