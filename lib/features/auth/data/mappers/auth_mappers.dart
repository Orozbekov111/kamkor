import 'package:kamkor/features/auth/data/models/auth_token_model.dart';
import 'package:kamkor/features/auth/data/models/user_model.dart';
import 'package:kamkor/features/auth/domain/entities/session.dart';
import 'package:kamkor/features/auth/domain/entities/user.dart';

extension UserModelMapper on UserModel {
  User toEntity() => User(
        id: id,
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        region: region,
        uvdCode: uvdCode,
        address: address,
        icon: icon,
      );
}

extension AuthTokenModelMapper on AuthTokenModel {
  /// [token] is the persisted auth token, since `me` does not echo it back.
  Session toSession(String token) => Session(
        authToken: token,
        user: user.toEntity(),
        sosButtonAvailable: sosButtonAvailable ?? false,
      );
}
