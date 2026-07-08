import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:kamkor/core/error/failures.dart';
import 'package:kamkor/features/auth/domain/entities/session.dart';
import 'package:kamkor/features/auth/domain/usecases/get_current_session.dart';
import 'package:kamkor/features/profile/domain/usecases/update_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// Handles profile edits. Reading the user is left to the global `AuthBloc`
/// (the single source of user data); after a successful update this bloc
/// re-fetches the session via auth's [GetCurrentSession] and exposes it so the
/// view can refresh `AuthBloc`.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UpdateProfile updateProfile,
    required GetCurrentSession getCurrentSession,
  })  : _updateProfile = updateProfile,
        _getCurrentSession = getCurrentSession,
        super(const ProfileState()) {
    on<ProfileSubmitted>(_onSubmitted, transformer: droppable());
    on<ProfileOpReset>(
      (_, emit) => emit(state.copyWith(status: ProfileOpStatus.idle)),
    );
  }

  final UpdateProfile _updateProfile;
  final GetCurrentSession _getCurrentSession;

  Future<void> _onSubmitted(
    ProfileSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileOpStatus.saving));
    final result = await _updateProfile(
      name: event.name,
      surname: event.surname,
      phoneNumber: event.phoneNumber,
      address: event.address,
    );
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: ProfileOpStatus.failure,
          error: _map(failure),
        ),
      ),
      (_) async {
        // Refresh the session so the whole app sees the new values.
        final refreshed = await _getCurrentSession();
        emit(
          state.copyWith(
            status: ProfileOpStatus.success,
            session: refreshed.getOrElse(() => null),
          ),
        );
      },
    );
  }

  ProfileError _map(Failure failure) => switch (failure) {
        NetworkFailure() => ProfileError.network,
        TimeoutFailure() => ProfileError.timeout,
        ValidationFailure() => ProfileError.validation,
        ServerFailure() => ProfileError.server,
        _ => ProfileError.unknown,
      };
}
