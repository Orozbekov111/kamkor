import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/info/domain/entities/info_item.dart';
import 'package:kamkor/features/info/domain/repositories/info_repository.dart';

class GetCrisisCenters {
  const GetCrisisCenters(this._repository);

  final InfoRepository _repository;

  ResultFuture<List<InfoItem>> call() => _repository.getCrisisCenters();
}
