import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/auth/domain/entities/session.dart';
import 'package:kamkor/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  const LoginUser(this._repository);

  final AuthRepository _repository;

  ResultFuture<Session> call({
    required String token,
    required String pin,
    required String device,
  }) =>
      _repository.login(token: token, pin: pin, device: device);
}
