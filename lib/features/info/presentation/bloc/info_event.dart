part of 'info_bloc.dart';

sealed class InfoEvent extends Equatable {
  const InfoEvent();

  @override
  List<Object?> get props => [];
}

class InfoSectionRequested extends InfoEvent {
  const InfoSectionRequested(this.section);

  final InfoSection section;

  @override
  List<Object?> get props => [section];
}
