import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kamkor/features/sos_history/domain/entities/sos_history_item.dart';
import 'package:kamkor/features/sos_history/domain/usecases/get_sos_history_item.dart';
import 'package:kamkor/features/sos_history/presentation/bloc/sos_history_bloc.dart';

part 'sos_history_detail_event.dart';
part 'sos_history_detail_state.dart';

/// Loads a single past SOS request by id for the detail screen.
class SosHistoryDetailBloc
    extends Bloc<SosHistoryDetailEvent, SosHistoryDetailState> {
  SosHistoryDetailBloc({required GetSosHistoryItem getItem})
      : _getItem = getItem,
        super(const SosHistoryDetailState()) {
    on<SosHistoryDetailRequested>(_onRequested);
  }

  final GetSosHistoryItem _getItem;

  Future<void> _onRequested(
    SosHistoryDetailRequested event,
    Emitter<SosHistoryDetailState> emit,
  ) async {
    emit(state.copyWith(status: SosHistoryStatus.loading));
    final result = await _getItem(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SosHistoryStatus.failure,
          error: mapFailureToHistoryError(failure),
        ),
      ),
      (item) => emit(
        state.copyWith(status: SosHistoryStatus.ready, item: item),
      ),
    );
  }
}
