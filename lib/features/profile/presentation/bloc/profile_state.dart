part of 'profile_bloc.dart';

enum ProfileOpStatus { idle, saving, success, failure }

enum ProfileError { none, network, timeout, validation, server, unknown }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileOpStatus.idle,
    this.error = ProfileError.none,
    this.session,
  });

  final ProfileOpStatus status;
  final ProfileError error;

  /// The refreshed session after a successful update, if it could be reloaded.
  final Session? session;

  bool get isSaving => status == ProfileOpStatus.saving;

  ProfileState copyWith({
    ProfileOpStatus? status,
    ProfileError? error,
    Session? session,
  }) =>
      ProfileState(
        status: status ?? this.status,
        // Clear the error when a new op begins.
        error: error ?? (status == null ? this.error : ProfileError.none),
        session: session ?? this.session,
      );

  @override
  List<Object?> get props => [status, error, session];
}
