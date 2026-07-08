import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile {
  const UpdateProfile(this._repository);

  final ProfileRepository _repository;

  ResultVoid call({
    String? name,
    String? surname,
    String? phoneNumber,
    String? address,
    String? icon,
  }) =>
      _repository.updateProfile(
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        address: address,
        icon: icon,
      );
}
