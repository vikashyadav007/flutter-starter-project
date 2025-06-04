import 'package:dio/dio.dart';
import 'package:starter_project/core/config/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_refetch_client.g.dart';

@riverpod
Dio dioRefetchClient(Ref ref) {
  final appConfigProvider = ref.read(appConfigNotifierProvider);
  Dio dio = Dio(
    BaseOptions(
      baseUrl: appConfigProvider.apiBaseUrl,
      connectTimeout: appConfigProvider.timeout,
      receiveTimeout: appConfigProvider.timeout,
    ),
  );

  dio.interceptors.addAll([
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
