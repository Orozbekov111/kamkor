part of 'message_template_bloc.dart';

enum MtStatus { initial, loading, ready, failure }

enum MtSaveStatus { idle, saving, success, failure }

enum MtError { none, network, timeout, validation, server, unknown }

class MessageTemplateState extends Equatable {
  const MessageTemplateState({
    this.status = MtStatus.initial,
    this.template,
    this.loadError = MtError.none,
    this.saveStatus = MtSaveStatus.idle,
    this.saveError = MtError.none,
  });

  final MtStatus status;
  final MessageTemplate? template;
  final MtError loadError;
  final MtSaveStatus saveStatus;
  final MtError saveError;

  bool get isSaving => saveStatus == MtSaveStatus.saving;

  MessageTemplateState copyWith({
    MtStatus? status,
    MessageTemplate? template,
    MtError? loadError,
    MtSaveStatus? saveStatus,
    MtError? saveError,
  }) =>
      MessageTemplateState(
        status: status ?? this.status,
        template: template ?? this.template,
        loadError: loadError ?? this.loadError,
        saveStatus: saveStatus ?? this.saveStatus,
        // Reset the save error when a new save begins.
        saveError:
            saveError ?? (saveStatus == null ? this.saveError : MtError.none),
      );

  @override
  List<Object?> get props =>
      [status, template, loadError, saveStatus, saveError];
}
