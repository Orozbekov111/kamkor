part of 'sos_bloc.dart';

/// Whether recent location pushes are getting through.
enum SosConnection { online, reconnecting }

/// Why an alarm ended. A 409 doesn't say which, so [ended] is the default.
enum SosCloseReason { done, cancelled, ended }

/// Why the alarm could not be started (missing location access).
enum SosPermissionReason { serviceDisabled, denied, deniedForever }

/// Why activation failed (recoverable by retrying).
enum SosActivationError {
  network,
  timeout,
  server,
  locationUnavailable,
  unauthorized,
  unknown,
}

sealed class SosState extends Equatable {
  const SosState();

  @override
  List<Object?> get props => [];
}

/// No active alarm — the SOS button is shown.
class SosIdle extends SosState {
  const SosIdle();
}

/// Preflight + createSos in flight.
///
/// [attempt] tracks the persistent-creation retry round: 0 is the first try
/// (plain spinner); >0 means createSos keeps failing on a transient (network)
/// error and we are still retrying — the UI escalates its wording accordingly.
class SosActivating extends SosState {
  const SosActivating({this.attempt = 0});

  final int attempt;

  @override
  List<Object?> get props => [attempt];
}

/// Location access is missing; the UI explains and offers a settings shortcut.
class SosPermissionRequired extends SosState {
  const SosPermissionRequired(this.reason);

  final SosPermissionReason reason;

  @override
  List<Object?> get props => [reason];
}

/// The alarm is live: coordinates are being transmitted. Everything the active
/// screen renders lives here.
class SosActive extends SosState {
  const SosActive({
    required this.sos,
    required this.connection,
    this.lastSentAt,
  });

  final Sos sos;
  final SosConnection connection;

  /// When the last position was accepted by the server.
  final DateTime? lastSentAt;

  SosActive copyWith({
    SosConnection? connection,
    DateTime? lastSentAt,
  }) =>
      SosActive(
        sos: sos,
        connection: connection ?? this.connection,
        lastSentAt: lastSentAt ?? this.lastSentAt,
      );

  @override
  List<Object?> get props => [sos, connection, lastSentAt];
}

/// The alarm was closed by an operator; tracking has stopped.
class SosClosed extends SosState {
  const SosClosed(this.reason);

  final SosCloseReason reason;

  @override
  List<Object?> get props => [reason];
}

/// Activation failed before an alarm was created — safe to retry.
class SosFailure extends SosState {
  const SosFailure(this.error);

  final SosActivationError error;

  @override
  List<Object?> get props => [error];
}
