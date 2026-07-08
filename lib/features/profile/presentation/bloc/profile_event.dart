part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Submits a partial profile update. Null fields are left unchanged.
///
/// The profile icon is not user-editable in this app, so it is not part of the
/// event — the update use case simply leaves it unchanged.
class ProfileSubmitted extends ProfileEvent {
  const ProfileSubmitted({
    this.name,
    this.surname,
    this.phoneNumber,
    this.address,
  });

  final String? name;
  final String? surname;
  final String? phoneNumber;
  final String? address;

  @override
  List<Object?> get props => [name, surname, phoneNumber, address];
}

class ProfileOpReset extends ProfileEvent {
  const ProfileOpReset();
}
