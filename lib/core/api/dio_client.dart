import 'package:dio/dio.dart';
import 'package:fuel_pro_360/core/api/interceptors/auth_interceptor.dart';
import 'package:fuel_pro_360/core/config/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
Dio dioClient(Ref ref) {
  final appConfigProvider = ref.read(appConfigNotifierProvider);

  Dio dio = Dio(
    BaseOptions(
      baseUrl: appConfigProvider.apiBaseUrl,
      connectTimeout: appConfigProvider.timeout,
      receiveTimeout: appConfigProvider.timeout,
    ),
  );

  //TODO add this as per base project
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final currentConfig = ref.read(appConfigNotifierProvider);
        options.baseUrl = currentConfig.apiBaseUrl;
        return handler.next(options);
      },
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(ref),
    if (appConfigProvider.enableLogging)
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 80,
      ),
  ]);

  return dio;
}
