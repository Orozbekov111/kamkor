import 'package:equatable/equatable.dart';
import 'package:kamkor/features/sos/domain/entities/geo_point.dart';
import 'package:kamkor/features/sos/domain/entities/sos_status.dart';

/// An SOS alarm as known to the client.
class Sos extends Equatable {
  const Sos({
    required this.id,
    required this.status,
    this.createdAt,
    this.initialLocation,
  });

  final String id;
  final SosStatus status;
  final DateTime? createdAt;

  /// The geolocation captured when the alarm was created.
  final GeoPoint? initialLocation;

  Sos copyWith({SosStatus? status}) => Sos(
        id: id,
        status: status ?? this.status,
        createdAt: createdAt,
        initialLocation: initialLocation,
      );

  @override
  List<Object?> get props => [id, status, createdAt, initialLocation];
}
