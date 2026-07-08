import 'package:dartz/dartz.dart';
import 'package:kamkor/core/error/exceptions.dart';
import 'package:kamkor/core/error/failure_mapper.dart';
import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/contacts/data/datasources/contacts_remote_data_source.dart';
import 'package:kamkor/features/contacts/data/mappers/contact_mappers.dart';
import 'package:kamkor/features/contacts/domain/entities/contact.dart';
import 'package:kamkor/features/contacts/domain/repositories/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  ContactsRepositoryImpl(this._remote);

  final ContactsRemoteDataSource _remote;

  @override
  ResultFuture<List<Contact>> getContacts() async {
    try {
      final models = await _remote.getContacts();
      final contacts = models.map((m) => m.toEntity()).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return Right(contacts);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  ResultFuture<Contact> addContact({
    required String name,
    required String phoneNumber,
  }) async {
    try {
      final model = await _remote.addContact(
        name: name,
        phoneNumber: phoneNumber,
      );
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  ResultFuture<Contact> updateContact({
    required int id,
    String? name,
    String? phoneNumber,
  }) async {
    try {
      final model = await _remote.updateContact(
        id: id,
        name: name,
        phoneNumber: phoneNumber,
      );
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  ResultVoid deleteContact(int id) async {
    try {
      await _remote.deleteContact(id);
      return const Right(null);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
