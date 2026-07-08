import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/contacts/domain/repositories/contacts_repository.dart';

class DeleteContact {
  const DeleteContact(this._repository);

  final ContactsRepository _repository;

  ResultVoid call(int id) => _repository.deleteContact(id);
}
