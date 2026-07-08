part of 'sos_bloc.dart';

sealed class SosEvent extends Equatable {
  const SosEvent();

  @override
  List<Object?> get props => [];
}

/// User pressed (and held) the SOS button. Handled with `droppable()` so a
/// second press while activation is in flight can never create a second alarm.
class SosTriggered extends SosEvent {
  const SosTriggered();
}

/// Re-run monitoring for an alarm restored from storage after a restart.
class SosRestoreRequested extends SosEvent {
  const SosRestoreRequested();
}

/// Acknowledge a closed/failed alarm and return to idle.
class SosDismissed extends SosEvent {
  const SosDismissed();
}

/// Open the OS app-settings page (permission recovery).
class SosAppSettingsRequested extends SosEvent {
  const SosAppSettingsRequested();
}

/// Open the OS location-services page (service disabled recovery).
class SosLocationServiceRequested extends SosEvent {
  const SosLocationServiceRequested();
}

/// Internal: a fresh position fix to transmit (from the monitoring stream).
class _LocationTick extends SosEvent {
  const _LocationTick(this.point);

  final GeoPoint point;

  @override
  List<Object?> get props => [point];
}

/// Internal: a 409 was observed — the alarm is closed, stop everything.
class _SosClosedDetected extends SosEvent {
  const _SosClosedDetected(this.reason);

  final SosCloseReason reason;

  @override
  List<Object?> get props => [reason];
}
