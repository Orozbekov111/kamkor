import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';

/// Key emergency services, bundled in the app so the critical numbers are
/// available even with no network. Labels are localized; numbers are the
/// nationwide Kyrgyzstan short codes.
enum EmergencyService { unified, police, ambulance, fire, gas }

class EmergencyContact {
  const EmergencyContact(this.service, this.number);

  final EmergencyService service;
  final String number;
}

const List<EmergencyContact> kEmergencyContacts = [
  EmergencyContact(EmergencyService.unified, '112'),
  EmergencyContact(EmergencyService.police, '102'),
  EmergencyContact(EmergencyService.ambulance, '103'),
  EmergencyContact(EmergencyService.fire, '101'),
  EmergencyContact(EmergencyService.gas, '104'),
];

String emergencyServiceLabel(AppLocalizations l, EmergencyService service) =>
    switch (service) {
      EmergencyService.unified => l.emergency_service_112,
      EmergencyService.police => l.emergency_service_police,
      EmergencyService.ambulance => l.emergency_service_ambulance,
      EmergencyService.fire => l.emergency_service_fire,
      EmergencyService.gas => l.emergency_service_gas,
    };
