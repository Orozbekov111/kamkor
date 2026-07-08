import 'package:equatable/equatable.dart';

/// Authenticated user profile (domain entity, no JSON concerns).
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    this.surname,
    this.phoneNumber,
    this.region,
    this.uvdCode,
    this.address,
    this.icon,
  });

  final int id;
  final String name;
  final String? surname;
  final String? phoneNumber;
  final String? region;
  final String? uvdCode;
  final String? address;
  final String? icon;

  @override
  List<Object?> get props =>
      [id, name, surname, phoneNumber, region, uvdCode, address, icon];
}
