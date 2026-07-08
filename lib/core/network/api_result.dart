import 'package:dio/dio.dart';
import 'package:kamkor/core/error/exceptions.dart';

/// Runs a remote call and normalizes errors to [AppException].
/// [DioException]s already carry a mapped exception (see ErrorInterceptor).
Future<T> safeApiCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    final error = e.error;
    throw error is AppException ? error : const UnknownException();
  } on AppException {
    rethrow;
  } on Object catch (_) {
    // Any other error is normalized to a single unknown exception.
    throw const UnknownException();
  }
}
