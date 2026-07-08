part of 'sos_history_detail_bloc.dart';

class SosHistoryDetailState extends Equatable {
  const SosHistoryDetailState({
    this.status = SosHistoryStatus.initial,
    this.item,
    this.error = SosHistoryError.unknown,
  });

  final SosHistoryStatus status;
  final SosHistoryItem? item;
  final SosHistoryError error;

  SosHistoryDetailState copyWith({
    SosHistoryStatus? status,
    SosHistoryItem? item,
    SosHistoryError? error,
  }) =>
      SosHistoryDetailState(
        status: status ?? this.status,
        item: item ?? this.item,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, item, error];
}
