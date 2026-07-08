import 'package:equatable/equatable.dart';

/// The SOS message template (domain entity).
///
/// [geoSignature] may contain the `{geo}` placeholder, which the backend
/// replaces with live coordinates when the alarm fires.
class MessageTemplate extends Equatable {
  const MessageTemplate({
    required this.messageText,
    required this.geoSignature,
  });

  /// Backend field limits, mirrored here to drive the editor's counters.
  static const int maxMessageLength = 500;
  static const int maxGeoSignatureLength = 200;

  /// Placeholder replaced with live coordinates on send.
  static const String geoPlaceholder = '{geo}';

  final String messageText;
  final String geoSignature;

  @override
  List<Object?> get props => [messageText, geoSignature];
}
