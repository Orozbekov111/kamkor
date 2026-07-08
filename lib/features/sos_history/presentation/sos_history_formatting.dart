import 'package:intl/intl.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/features/sos_history/presentation/bloc/sos_history_bloc.dart';

// Locale-independent numeric format — safe for every supported locale.
final DateFormat _timestampFormat = DateFormat('dd.MM.yyyy, HH:mm');

/// Formats an SOS timestamp, or a fallback when it is missing.
String formatSosTimestamp(AppLocalizations l, DateTime? at) =>
    at == null ? l.sos_history_no_date : _timestampFormat.format(at.toLocal());

/// Parses a server-formatted `"lat, lng"` geolocation string into coordinates,
/// or `null` when it is missing or malformed.
({double lat, double lng})? parseGeo(String? geo) {
  if (geo == null) return null;
  final parts = geo.split(',');
  if (parts.length != 2) return null;
  final lat = double.tryParse(parts[0].trim());
  final lng = double.tryParse(parts[1].trim());
  if (lat == null || lng == null) return null;
  return (lat: lat, lng: lng);
}

String sosHistoryErrorText(AppLocalizations l, SosHistoryError error) =>
    switch (error) {
      SosHistoryError.network => l.error_network,
      SosHistoryError.timeout => l.error_timeout,
      SosHistoryError.server => l.error_server,
      SosHistoryError.unknown => l.error_unknown,
    };
