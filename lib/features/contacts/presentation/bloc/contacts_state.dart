part of 'contacts_bloc.dart';

enum ContactsStatus { initial, loading, ready, failure }

/// Outcome of the last create/update/delete mutation.
enum ContactsOp {
  none,
  saving,
  saveSuccess,
  saveFailure,
  deleting,
  deleteSuccess,
  deleteFailure,
}

enum ContactsError {
  none,
  duplicatePhone,
  validation,
  network,
  timeout,
  server,
  unknown,
}

class ContactsState extends Equatable {
  const ContactsState({
    this.status = ContactsStatus.initial,
    this.contacts = const [],
    this.loadError = ContactsError.none,
    this.op = ContactsOp.none,
    this.opError = ContactsError.none,
  });

  final ContactsStatus status;
  final List<Contact> contacts;
  final ContactsError loadError;
  final ContactsOp op;
  final ContactsError opError;

  bool get isSaving => op == ContactsOp.saving;

  ContactsState copyWith({
    ContactsStatus? status,
    List<Contact>? contacts,
    ContactsError? loadError,
    ContactsOp? op,
    ContactsError? opError,
  }) =>
      ContactsState(
        status: status ?? this.status,
        contacts: contacts ?? this.contacts,
        loadError: loadError ?? this.loadError,
        op: op ?? this.op,
        // Reset the op error whenever a new op begins or on explicit clear.
        opError: opError ?? (op == null ? this.opError : ContactsError.none),
      );

  @override
  List<Object?> get props => [status, contacts, loadError, op, opError];
}
