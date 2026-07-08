part of 'sos_history_detail_bloc.dart';

sealed class SosHistoryDetailEvent extends Equatable {
  const SosHistoryDetailEvent();

  @override
  List<Object?> get props => [];
}

class SosHistoryDetailRequested extends SosHistoryDetailEvent {
  const SosHistoryDetailRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}
