import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/auth/domain/entities/session.dart';

abstract interface class AuthRepository {
  /// Returns whether the access token from the QR/link is valid.
  ResultFuture<bool> validateAccessLink(String token);

  /// Authenticates with the access token + PIN and persists the session.
  ResultFuture<Session> login({
    required String token,
    required String pin,
    required String device,
  });

  /// Restores the current session, or `Right(null)` if none is stored.
  ResultFuture<Session?> getCurrentSession();

  /// Revokes the current device token (server + local).
  ResultVoid logout();
}
