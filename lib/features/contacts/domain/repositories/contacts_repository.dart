import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/contacts/domain/entities/contact.dart';

abstract interface class ContactsRepository {
  /// Trusted contacts, sorted by name.
  ResultFuture<List<Contact>> getContacts();

  /// Creates a contact; the phone number is unique per user.
  ResultFuture<Contact> addContact({
    required String name,
    required String phoneNumber,
  });

  /// Partially updates a contact (name and/or phone number).
  ResultFuture<Contact> updateContact({
    required int id,
    String? name,
    String? phoneNumber,
  });

  ResultVoid deleteContact(int id);
}
