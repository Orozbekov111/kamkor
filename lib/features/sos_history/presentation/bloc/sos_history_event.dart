part of 'sos_history_bloc.dart';

sealed class SosHistoryEvent extends Equatable {
  const SosHistoryEvent();

  @override
  List<Object?> get props => [];
}

class SosHistoryRequested extends SosHistoryEvent {
  const SosHistoryRequested();
}
