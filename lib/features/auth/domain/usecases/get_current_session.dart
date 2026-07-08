import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/auth/domain/entities/session.dart';
import 'package:kamkor/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentSession {
  const GetCurrentSession(this._repository);

  final AuthRepository _repository;

  ResultFuture<Session?> call() => _repository.getCurrentSession();
}
