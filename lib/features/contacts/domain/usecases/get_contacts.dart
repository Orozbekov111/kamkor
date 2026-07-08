import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/contacts/domain/entities/contact.dart';
import 'package:kamkor/features/contacts/domain/repositories/contacts_repository.dart';

class GetContacts {
  const GetContacts(this._repository);

  final ContactsRepository _repository;

  ResultFuture<List<Contact>> call() => _repository.getContacts();
}
