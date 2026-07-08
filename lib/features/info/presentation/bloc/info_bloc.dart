import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kamkor/core/error/failures.dart';
import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/info/domain/entities/info_item.dart';
import 'package:kamkor/features/info/domain/entities/info_section.dart';
import 'package:kamkor/features/info/domain/usecases/get_crisis_centers.dart';
import 'package:kamkor/features/info/domain/usecases/get_emergency_instructions.dart';
import 'package:kamkor/features/info/domain/usecases/get_privacy_policy.dart';
import 'package:kamkor/features/info/domain/usecases/get_psychological_help.dart';

part 'info_event.dart';
part 'info_state.dart';

/// Loads the articles of a single [InfoSection]. One bloc instance backs one
/// section screen.
class InfoBloc extends Bloc<InfoEvent, InfoState> {
  InfoBloc({
    required GetCrisisCenters getCrisisCenters,
    required GetPsychologicalHelp getPsychologicalHelp,
    required GetEmergencyInstructions getEmergencyInstructions,
    required GetPrivacyPolicy getPrivacyPolicy,
  })  : _getCrisisCenters = getCrisisCenters,
        _getPsychologicalHelp = getPsychologicalHelp,
        _getEmergencyInstructions = getEmergencyInstructions,
        _getPrivacyPolicy = getPrivacyPolicy,
        super(const InfoState()) {
    on<InfoSectionRequested>(_onRequested);
  }

  final GetCrisisCenters _getCrisisCenters;
  final GetPsychologicalHelp _getPsychologicalHelp;
  final GetEmergencyInstructions _getEmergencyInstructions;
  final GetPrivacyPolicy _getPrivacyPolicy;

  Future<void> _onRequested(
    InfoSectionRequested event,
    Emitter<InfoState> emit,
  ) async {
    emit(state.copyWith(status: InfoStatus.loading, section: event.section));
    final result = await _usecaseFor(event.section)();
    result.fold(
      (failure) => emit(
        state.copyWith(status: InfoStatus.failure, error: _map(failure)),
      ),
      (items) =>
          emit(state.copyWith(status: InfoStatus.ready, items: items)),
    );
  }

  ResultFuture<List<InfoItem>> Function() _usecaseFor(InfoSection section) =>
      switch (section) {
        InfoSection.crisisCenters => _getCrisisCenters.call,
        InfoSection.psychologicalHelp => _getPsychologicalHelp.call,
        InfoSection.emergencyInstructions => _getEmergencyInstructions.call,
        InfoSection.privacyPolicy => _getPrivacyPolicy.call,
      };

  InfoError _map(Failure failure) => switch (failure) {
        NetworkFailure() => InfoError.network,
        TimeoutFailure() => InfoError.timeout,
        ServerFailure() => InfoError.server,
        _ => InfoError.unknown,
      };
}
