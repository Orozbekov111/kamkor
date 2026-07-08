import 'package:equatable/equatable.dart';

/// A past SOS request of the current user (domain entity).
class SosHistoryItem extends Equatable {
  const SosHistoryItem({
    required this.id,
    this.geo,
    this.createdAt,
  });

  final int id;

  /// Server-formatted `"lat, lng"` geolocation string, if recorded.
  final String? geo;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, geo, createdAt];
}
