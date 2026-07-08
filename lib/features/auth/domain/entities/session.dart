import 'package:equatable/equatable.dart';
import 'package:kamkor/features/auth/domain/entities/user.dart';

/// An active authenticated session.
class Session extends Equatable {
  const Session({
    required this.authToken,
    required this.user,
    required this.sosButtonAvailable,
  });

  final String authToken;
  final User user;
  final bool sosButtonAvailable;

  @override
  List<Object?> get props => [authToken, user, sosButtonAvailable];
}
