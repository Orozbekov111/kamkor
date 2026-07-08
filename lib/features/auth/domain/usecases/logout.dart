import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/auth/domain/repositories/auth_repository.dart';

class Logout {
  const Logout(this._repository);

  final AuthRepository _repository;

  ResultVoid call() => _repository.logout();
}
