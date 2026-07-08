import 'package:dartz/dartz.dart';
import 'package:kamkor/core/error/exceptions.dart';
import 'package:kamkor/core/error/failure_mapper.dart';
import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:kamkor/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remote);

  final ProfileRemoteDataSource _remote;

  @override
  ResultVoid updateProfile({
    String? name,
    String? surname,
    String? phoneNumber,
    String? address,
    String? icon,
  }) async {
    try {
      await _remote.updateProfile(
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        address: address,
        icon: icon,
      );
      return const Right(null);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
