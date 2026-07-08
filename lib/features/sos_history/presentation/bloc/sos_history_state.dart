part of 'sos_history_bloc.dart';

enum SosHistoryStatus { initial, loading, ready, failure }

enum SosHistoryError { network, timeout, server, unknown }

SosHistoryError mapFailureToHistoryError(Failure failure) => switch (failure) {
      NetworkFailure() => SosHistoryError.network,
      TimeoutFailure() => SosHistoryError.timeout,
      ServerFailure() => SosHistoryError.server,
      _ => SosHistoryError.unknown,
    };

class SosHistoryState extends Equatable {
  const SosHistoryState({
    this.status = SosHistoryStatus.initial,
    this.items = const [],
    this.error = SosHistoryError.unknown,
  });

  final SosHistoryStatus status;
  final List<SosHistoryItem> items;
  final SosHistoryError error;

  SosHistoryState copyWith({
    SosHistoryStatus? status,
    List<SosHistoryItem>? items,
    SosHistoryError? error,
  }) =>
      SosHistoryState(
        status: status ?? this.status,
        items: items ?? this.items,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, items, error];
}
