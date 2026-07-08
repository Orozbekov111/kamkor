import 'package:dartz/dartz.dart';
import 'package:kamkor/core/error/exceptions.dart';
import 'package:kamkor/core/error/failure_mapper.dart';
import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/info/data/datasources/info_remote_data_source.dart';
import 'package:kamkor/features/info/data/mappers/info_mappers.dart';
import 'package:kamkor/features/info/data/models/info_item_model.dart';
import 'package:kamkor/features/info/domain/entities/info_item.dart';
import 'package:kamkor/features/info/domain/repositories/info_repository.dart';

class InfoRepositoryImpl implements InfoRepository {
  InfoRepositoryImpl(this._remote);

  final InfoRemoteDataSource _remote;

  @override
  ResultFuture<List<InfoItem>> getCrisisCenters() =>
      _guard(_remote.crisisCenters);

  @override
  ResultFuture<List<InfoItem>> getPsychologicalHelp() =>
      _guard(_remote.psychologicalHelp);

  @override
  ResultFuture<List<InfoItem>> getEmergencyInstructions() =>
      _guard(_remote.emergencyInstructions);

  @override
  ResultFuture<List<InfoItem>> getPrivacyPolicy() =>
      _guard(_remote.privacyPolicy);

  /// Shared fetch/map/error pipeline — the four sections differ only by call.
  ResultFuture<List<InfoItem>> _guard(
    Future<List<InfoItemModel>> Function() call,
  ) async {
    try {
      final models = await call();
      return Right(models.map((m) => m.toEntity()).toList());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
