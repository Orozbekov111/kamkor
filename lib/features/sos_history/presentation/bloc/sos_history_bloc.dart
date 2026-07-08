import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kamkor/core/error/failures.dart';
import 'package:kamkor/features/sos_history/domain/entities/sos_history_item.dart';
import 'package:kamkor/features/sos_history/domain/usecases/get_sos_history.dart';

part 'sos_history_event.dart';
part 'sos_history_state.dart';

/// Loads the list of the user's past SOS requests.
class SosHistoryBloc extends Bloc<SosHistoryEvent, SosHistoryState> {
  SosHistoryBloc({required GetSosHistory getHistory})
      : _getHistory = getHistory,
        super(const SosHistoryState()) {
    on<SosHistoryRequested>(_onRequested);
  }

  final GetSosHistory _getHistory;

  Future<void> _onRequested(
    SosHistoryRequested event,
    Emitter<SosHistoryState> emit,
  ) async {
    emit(state.copyWith(status: SosHistoryStatus.loading));
    final result = await _getHistory();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SosHistoryStatus.failure,
          error: mapFailureToHistoryError(failure),
        ),
      ),
      (items) => emit(
        state.copyWith(status: SosHistoryStatus.ready, items: items),
      ),
    );
  }
}
