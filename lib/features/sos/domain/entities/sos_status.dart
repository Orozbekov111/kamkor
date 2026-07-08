/// Lifecycle status of an SOS alarm, as owned by the backend.
///
/// [unknown] keeps the client tolerant: an unexpected status string from the
/// server must never crash a person's active alarm.
enum SosStatus {
  pending,
  inProgress,
  done,
  cancelled,
  unknown;

  /// Tolerant parse of the backend's snake_case status string.
  static SosStatus fromApi(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'pending':
        return SosStatus.pending;
      case 'in_progress':
        return SosStatus.inProgress;
      case 'done':
        return SosStatus.done;
      case 'cancelled':
      case 'canceled':
        return SosStatus.cancelled;
      default:
        return SosStatus.unknown;
    }
  }

  /// The alarm is still live and accepts location updates.
  bool get isActive =>
      this == SosStatus.pending || this == SosStatus.inProgress;

  /// The alarm was closed by an operator (server rejects further updates).
  bool get isClosed => this == SosStatus.done || this == SosStatus.cancelled;
}
