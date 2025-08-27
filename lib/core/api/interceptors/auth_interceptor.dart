import 'package:dio/dio.dart';
import 'package:fuel_pro_360/core/api/api_client.dart';
import 'package:fuel_pro_360/core/api/dio_refetch_client.dart';
import 'package:fuel_pro_360/features/auth/presentation/providers/auth_provider.dart';
import 'package:fuel_pro_360/features/auth/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/constants/api_constants.dart';
import 'package:fuel_pro_360/shared/providers/auth_credential_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  AuthInterceptor(this._ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final credentials = _ref.read(authCredentialProvider);

      print("credentials: $credentials");

      if (options.path == ApiConstants.login) {
      } else if (credentials == null) {
        throw DioException(
          requestOptions: options,
          error: 'No authentication credentials found',
        );
      } else {
        options.headers['Authorization'] = credentials.basicAuth;
      }
      handler.next(options);
    } catch (e) {
      handler.reject(
        DioError(
          requestOptions: options,
          error: 'Failed to add authentication header: $e',
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final authLocalDataSource = _ref.read(authLocalDataSourceProvider);
      final dioRefetchClient = _ref.read(dioRefetchClientProvider);

      final apiClient = ApiClient(dioRefetchClient);

      final String? refreshToken = await authLocalDataSource.getRefreshToken();
      print("refreshToken: $refreshToken");

      if (refreshToken != null) {
        try {
          final response = await apiClient.refreshToken({
            "refresh": refreshToken,
          });

          await authLocalDataSource.cacheToken(response.access);

          final retryRequest = err.requestOptions
            ..headers['Authorization'] = 'Bearer ${response.access}';

          handler.resolve(await dioRefetchClient.fetch(retryRequest));
          return;
        } catch (e) {
          print("Error refreshing token: $e");
          _ref.read(authProvider.notifier).logout();

          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: 'Session expired',
            ),
          );
          return;
        }
      }
    }
    handler.next(err);
  }
}
