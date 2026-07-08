import 'package:equatable/equatable.dart';

/// A trusted contact that receives the alarm signal (domain entity).
class Contact extends Equatable {
  const Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  final int id;
  final String name;
  final String phoneNumber;

  @override
  List<Object?> get props => [id, name, phoneNumber];
}
