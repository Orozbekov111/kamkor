part of 'contacts_bloc.dart';

sealed class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads (or reloads) the contacts list.
class ContactsRequested extends ContactsEvent {
  const ContactsRequested();
}

/// Creates a contact when [id] is null, otherwise updates it.
class ContactSaved extends ContactsEvent {
  const ContactSaved({
    required this.name,
    required this.phoneNumber,
    this.id,
  });

  final int? id;
  final String name;
  final String phoneNumber;

  @override
  List<Object?> get props => [id, name, phoneNumber];
}

class ContactDeleted extends ContactsEvent {
  const ContactDeleted(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

/// Clears the last mutation outcome so a reopened form starts clean.
class ContactsOpReset extends ContactsEvent {
  const ContactsOpReset();
}
