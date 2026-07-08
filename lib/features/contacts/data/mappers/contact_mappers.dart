import 'package:kamkor/features/contacts/data/models/contact_model.dart';
import 'package:kamkor/features/contacts/domain/entities/contact.dart';

extension ContactModelMapper on ContactModel {
  Contact toEntity() =>
      Contact(id: id, name: name, phoneNumber: phoneNumber);
}
