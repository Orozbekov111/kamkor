import 'package:dartz/dartz.dart';
import 'package:kamkor/core/error/exceptions.dart';
import 'package:kamkor/core/error/failure_mapper.dart';
import 'package:kamkor/core/storage/secure_storage.dart';
import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:kamkor/features/auth/data/mappers/auth_mappers.dart';
import 'package:kamkor/features/auth/domain/entities/session.dart';
import 'package:kamkor/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._storage);

  final AuthRemoteDataSource _remote;
  final SecureStorage _storage;

  @override
  ResultFuture<bool> validateAccessLink(String token) async {
    try {
      return Right(await _remote.validateAccessLink(token));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  ResultFuture<Session> login({
    required String token,
    required String pin,
    required String device,
  }) async {
    try {
      final auth = await _remote.login(token: token, pin: pin, device: device);
      final authToken = auth.authToken!; // always present on a 200 response
      await _storage.writeToken(authToken);
      // `me` is the single source of truth for the session (incl. SOS flag).
      final me = await _remote.getMe();
      return Right(me.toSession(authToken));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  ResultFuture<Session?> getCurrentSession() async {
    final token = await _storage.readToken();
    if (token == null || token.isEmpty) return const Right(null);
    try {
      final me = await _remote.getMe();
      return Right(me.toSession(token));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  ResultVoid logout() async {
    try {
      await _remote.logout();
    } on AppException {
      // Server errors are ignored — the local session must be cleared anyway.
    }
    await _storage.deleteToken();
    return const Right(null);
  }
}
