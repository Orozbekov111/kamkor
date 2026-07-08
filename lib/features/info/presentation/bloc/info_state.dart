part of 'info_bloc.dart';

enum InfoStatus { initial, loading, ready, failure }

enum InfoError { network, timeout, server, unknown }

class InfoState extends Equatable {
  const InfoState({
    this.status = InfoStatus.initial,
    this.section = InfoSection.crisisCenters,
    this.items = const [],
    this.error = InfoError.unknown,
  });

  final InfoStatus status;
  final InfoSection section;
  final List<InfoItem> items;
  final InfoError error;

  InfoState copyWith({
    InfoStatus? status,
    InfoSection? section,
    List<InfoItem>? items,
    InfoError? error,
  }) =>
      InfoState(
        status: status ?? this.status,
        section: section ?? this.section,
        items: items ?? this.items,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, section, items, error];
}
