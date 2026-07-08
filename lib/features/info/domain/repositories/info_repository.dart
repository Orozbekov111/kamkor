import 'package:kamkor/core/utils/typedefs.dart';
import 'package:kamkor/features/info/domain/entities/info_item.dart';

abstract interface class InfoRepository {
  ResultFuture<List<InfoItem>> getCrisisCenters();

  ResultFuture<List<InfoItem>> getPsychologicalHelp();

  ResultFuture<List<InfoItem>> getEmergencyInstructions();

  /// Privacy policy. Fetched via POST (the backend contract), without a token.
  ResultFuture<List<InfoItem>> getPrivacyPolicy();
}
