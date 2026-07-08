import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/contacts/domain/entities/contact.dart';
import 'package:kamkor/features/contacts/domain/repositories/contacts_repository.dart';

class AddContact {
  const AddContact(this._repository);

  final ContactsRepository _repository;

  ResultFuture<Contact> call({
    required String name,
    required String phoneNumber,
  }) =>
      _repository.addContact(name: name, phoneNumber: phoneNumber);
}
