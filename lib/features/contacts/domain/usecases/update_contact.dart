import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/contacts/domain/entities/contact.dart';
import 'package:kamkor/features/contacts/domain/repositories/contacts_repository.dart';

class UpdateContact {
  const UpdateContact(this._repository);

  final ContactsRepository _repository;

  ResultFuture<Contact> call({
    required int id,
    String? name,
    String? phoneNumber,
  }) =>
      _repository.updateContact(id: id, name: name, phoneNumber: phoneNumber);
}
