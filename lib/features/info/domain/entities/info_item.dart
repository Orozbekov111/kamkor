import 'package:equatable/equatable.dart';

/// A public reference article (crisis centers, psychological help, emergency
/// instructions or privacy policy). [body] unifies the backend's `content`
/// (guides) and `text` (privacy policy) fields.
class InfoItem extends Equatable {
  const InfoItem({
    required this.id,
    required this.title,
    required this.body,
    this.createdAt,
  });

  final int id;
  final String title;
  final String body;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, title, body, createdAt];
}
