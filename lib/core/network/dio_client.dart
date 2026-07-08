import 'package:dio/dio.dart';
import 'package:kamkor/core/config/app_config.dart';
import 'package:kamkor/core/network/interceptors/auth_interceptor.dart';
import 'package:kamkor/core/network/interceptors/error_interceptor.dart';
import 'package:kamkor/core/network/interceptors/logger_interceptor.dart';
import 'package:kamkor/core/storage/secure_storage.dart';

/// Builds the app-wide [Dio] instance with interceptors in order.
abstract final class DioClient {
  static Dio create(SecureStorage storage) {
    return Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {'Accept': 'application/json'},
      ),
    )..interceptors.addAll([
        AuthInterceptor(storage),
        ErrorInterceptor(),
        LoggerInterceptor(),
      ]);
  }
}
