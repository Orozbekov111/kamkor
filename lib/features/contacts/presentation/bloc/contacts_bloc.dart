import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:kamkor/core/error/failures.dart';
import 'package:kamkor/features/contacts/domain/entities/contact.dart';
import 'package:kamkor/features/contacts/domain/usecases/add_contact.dart';
import 'package:kamkor/features/contacts/domain/usecases/delete_contact.dart';
import 'package:kamkor/features/contacts/domain/usecases/get_contacts.dart';
import 'package:kamkor/features/contacts/domain/usecases/update_contact.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

/// Manages the trusted-contacts list and its create/update/delete mutations.
///
/// The list is kept in state and patched in place on each successful mutation
/// (no full refetch), so the UI stays responsive. Mutations run sequentially.
class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc({
    required GetContacts getContacts,
    required AddContact addContact,
    required UpdateContact updateContact,
    required DeleteContact deleteContact,
  })  : _getContacts = getContacts,
        _addContact = addContact,
        _updateContact = updateContact,
        _deleteContact = deleteContact,
        super(const ContactsState()) {
    on<ContactsRequested>(_onRequested);
    on<ContactSaved>(_onSaved, transformer: sequential());
    on<ContactDeleted>(_onDeleted, transformer: sequential());
    on<ContactsOpReset>((_, emit) => emit(state.copyWith(op: ContactsOp.none)));
  }

  final GetContacts _getContacts;
  final AddContact _addContact;
  final UpdateContact _updateContact;
  final DeleteContact _deleteContact;

  Future<void> _onRequested(
    ContactsRequested event,
    Emitter<ContactsState> emit,
  ) async {
    emit(state.copyWith(status: ContactsStatus.loading));
    final result = await _getContacts();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ContactsStatus.failure,
          loadError: _mapFailure(failure),
        ),
      ),
      (contacts) => emit(
        state.copyWith(status: ContactsStatus.ready, contacts: contacts),
      ),
    );
  }

  Future<void> _onSaved(ContactSaved event, Emitter<ContactsState> emit) async {
    emit(state.copyWith(op: ContactsOp.saving));
    final future = event.id == null
        ? _addContact(name: event.name, phoneNumber: event.phoneNumber)
        : _updateContact(
            id: event.id!,
            name: event.name,
            phoneNumber: event.phoneNumber,
          );
    (await future).fold(
      (failure) => emit(
        state.copyWith(
          op: ContactsOp.saveFailure,
          opError: _mapFailure(failure),
        ),
      ),
      (contact) => emit(
        state.copyWith(
          contacts: _upsert(state.contacts, contact),
          op: ContactsOp.saveSuccess,
        ),
      ),
    );
  }

  Future<void> _onDeleted(
    ContactDeleted event,
    Emitter<ContactsState> emit,
  ) async {
    emit(state.copyWith(op: ContactsOp.deleting));
    final result = await _deleteContact(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          op: ContactsOp.deleteFailure,
          opError: _mapFailure(failure),
        ),
      ),
      (_) => emit(
        state.copyWith(
          contacts: state.contacts.where((c) => c.id != event.id).toList(),
          op: ContactsOp.deleteSuccess,
        ),
      ),
    );
  }

  /// Inserts or replaces [contact] by id, keeping the list name-sorted.
  List<Contact> _upsert(List<Contact> list, Contact contact) {
    final next = [...list];
    final index = next.indexWhere((c) => c.id == contact.id);
    if (index >= 0) {
      next[index] = contact;
    } else {
      next.add(contact);
    }
    next.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return next;
  }

  ContactsError _mapFailure(Failure failure) => switch (failure) {
        // Phone-uniqueness (a `phone*` field error) vs any other validation.
        ValidationFailure(:final errors) => _isPhoneConflict(errors)
            ? ContactsError.duplicatePhone
            : ContactsError.validation,
        NetworkFailure() => ContactsError.network,
        TimeoutFailure() => ContactsError.timeout,
        ServerFailure() => ContactsError.server,
        _ => ContactsError.unknown,
      };

  /// Treats an absent error map as the (historically only) phone conflict.
  bool _isPhoneConflict(Map<String, List<String>>? errors) =>
      errors == null ||
      errors.keys.any((k) => k.toLowerCase().contains('phone'));
}
