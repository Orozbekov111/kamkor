import 'package:dartz/dartz.dart';
import 'package:kamkor/core/error/exceptions.dart';
import 'package:kamkor/core/error/failure_mapper.dart';
import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/sos_history/data/datasources/sos_history_remote_data_source.dart';
import 'package:kamkor/features/sos_history/data/mappers/sos_history_mappers.dart';
import 'package:kamkor/features/sos_history/domain/entities/sos_history_item.dart';
import 'package:kamkor/features/sos_history/domain/repositories/sos_history_repository.dart';

class SosHistoryRepositoryImpl implements SosHistoryRepository {
  SosHistoryRepositoryImpl(this._remote);

  final SosHistoryRemoteDataSource _remote;

  @override
  ResultFuture<List<SosHistoryItem>> getHistory() async {
    try {
      final models = await _remote.getHistory();
      return Right(models.map((m) => m.toEntity()).toList());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  ResultFuture<SosHistoryItem> getHistoryItem(int id) async {
    try {
      final model = await _remote.getHistoryItem(id);
      return Right(model.toEntity());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
