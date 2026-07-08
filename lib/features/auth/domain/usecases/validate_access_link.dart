import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/auth/domain/repositories/auth_repository.dart';

class ValidateAccessLink {
  const ValidateAccessLink(this._repository);

  final AuthRepository _repository;

  ResultFuture<bool> call(String token) =>
      _repository.validateAccessLink(token);
}
