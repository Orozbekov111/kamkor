import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kamkor/core/error/failures.dart';
import 'package:kamkor/features/auth/domain/entities/session.dart';
import 'package:kamkor/features/auth/domain/usecases/login_user.dart';
import 'package:kamkor/features/auth/domain/usecases/validate_access_link.dart';

part 'login_event.dart';
part 'login_state.dart';

/// Drives the login process: link/QR validation → PIN authentication.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required ValidateAccessLink validateAccessLink,
    required LoginUser loginUser,
  })  : _validateAccessLink = validateAccessLink,
        _loginUser = loginUser,
        super(const LoginState()) {
    on<AccessTokenSubmitted>(_onAccessTokenSubmitted);
    // droppable: ignore repeated PIN submits while one is in flight.
    on<PinSubmitted>(_onPinSubmitted, transformer: droppable());
    on<LoginRestarted>((_, emit) => emit(const LoginState()));
  }

  final ValidateAccessLink _validateAccessLink;
  final LoginUser _loginUser;

  Future<void> _onAccessTokenSubmitted(
    AccessTokenSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final token = _extractToken(event.input);
    if (token == null) {
      emit(state.copyWith(error: LoginError.linkRequired));
      return;
    }
    emit(state.copyWith(status: LoginStatus.loading, error: LoginError.none));
    final result = await _validateAccessLink(token);
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoginStatus.idle, error: _mapFailure(failure)),
      ),
      (valid) => emit(
        valid
            ? state.copyWith(
                status: LoginStatus.idle,
                phase: LoginPhase.enterPin,
                accessToken: token,
                error: LoginError.none,
              )
            : state.copyWith(
                status: LoginStatus.idle,
                error: LoginError.linkInvalid,
              ),
      ),
    );
  }

  Future<void> _onPinSubmitted(
    PinSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final token = state.accessToken;
    if (token == null) return;
    emit(state.copyWith(status: LoginStatus.loading, error: LoginError.none));
    final result = await _loginUser(
      token: token,
      pin: event.pin,
      device: defaultTargetPlatform.name,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoginStatus.idle, error: _mapFailure(failure)),
      ),
      (session) => emit(
        state.copyWith(status: LoginStatus.success, session: session),
      ),
    );
  }

  /// Accepts the full personal link (`?access=<token>`) or a bare token.
  String? _extractToken(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    final fromQuery = Uri.tryParse(trimmed)?.queryParameters['access'];
    if (fromQuery != null && fromQuery.isNotEmpty) return fromQuery;
    return trimmed.contains(RegExp(r'\s')) ? null : trimmed;
  }

  LoginError _mapFailure(Failure failure) => switch (failure) {
        NetworkFailure() => LoginError.network,
        TimeoutFailure() => LoginError.timeout,
        UnauthorizedFailure() => LoginError.wrongPin,
        ServerFailure() => LoginError.server,
        _ => LoginError.unknown,
      };
}
