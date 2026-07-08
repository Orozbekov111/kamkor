import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:kamkor/core/error/failures.dart';
import 'package:kamkor/features/message_template/domain/entities/message_template.dart';
import 'package:kamkor/features/message_template/domain/usecases/get_message_template.dart';
import 'package:kamkor/features/message_template/domain/usecases/update_message_template.dart';

part 'message_template_event.dart';
part 'message_template_state.dart';

/// Loads and saves the SOS message template. The saved values are echoed back
/// into state on success, so no extra read round-trip is needed.
class MessageTemplateBloc
    extends Bloc<MessageTemplateEvent, MessageTemplateState> {
  MessageTemplateBloc({
    required GetMessageTemplate getTemplate,
    required UpdateMessageTemplate updateTemplate,
  })  : _getTemplate = getTemplate,
        _updateTemplate = updateTemplate,
        super(const MessageTemplateState()) {
    on<MessageTemplateRequested>(_onRequested);
    on<MessageTemplateSaved>(_onSaved, transformer: droppable());
  }

  final GetMessageTemplate _getTemplate;
  final UpdateMessageTemplate _updateTemplate;

  Future<void> _onRequested(
    MessageTemplateRequested event,
    Emitter<MessageTemplateState> emit,
  ) async {
    emit(state.copyWith(status: MtStatus.loading));
    final result = await _getTemplate();
    result.fold(
      (failure) => emit(
        state.copyWith(status: MtStatus.failure, loadError: _map(failure)),
      ),
      (template) => emit(
        state.copyWith(status: MtStatus.ready, template: template),
      ),
    );
  }

  Future<void> _onSaved(
    MessageTemplateSaved event,
    Emitter<MessageTemplateState> emit,
  ) async {
    emit(state.copyWith(saveStatus: MtSaveStatus.saving));
    final result = await _updateTemplate(
      messageText: event.messageText,
      geoSignature: event.geoSignature,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          saveStatus: MtSaveStatus.failure,
          saveError: _map(failure),
        ),
      ),
      (_) => emit(
        state.copyWith(
          saveStatus: MtSaveStatus.success,
          template: MessageTemplate(
            messageText: event.messageText,
            geoSignature: event.geoSignature,
          ),
        ),
      ),
    );
  }

  MtError _map(Failure failure) => switch (failure) {
        NetworkFailure() => MtError.network,
        TimeoutFailure() => MtError.timeout,
        ValidationFailure() => MtError.validation,
        ServerFailure() => MtError.server,
        _ => MtError.unknown,
      };
}
