import 'package:kamkor/core/utils/typedefs.dart';

// Reading the profile reuses auth's session (single source of user data), so
// this contract intentionally exposes only the update operation.
// ignore: one_member_abstracts
abstract interface class ProfileRepository {
  /// Partially updates the current user. All fields are optional.
  ResultVoid updateProfile({
    String? name,
    String? surname,
    String? phoneNumber,
    String? address,
    String? icon,
  });
}
