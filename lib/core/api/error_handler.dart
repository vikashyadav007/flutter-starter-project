import 'package:dio/dio.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/core/routing/app_router.dart';
import 'package:fuel_pro_360/l10n/app_localizations_context.dart';
import 'package:fuel_pro_360/shared/constants/app_constants.dart';

class ErrorHandler implements Exception {
  late final Failure failure;
  ErrorHandler.handle(dynamic error) {
    failure =
        error is DioException
            ? _handleDioException(error)
            : DataSource.defaultError.getFailure();
  }

  Failure _handleDioException(DioException error) {
    final errorMap = {
      DioExceptionType.connectionTimeout: DataSource.connectTimeout,
      DioExceptionType.sendTimeout: DataSource.sendTimeout,
      DioExceptionType.receiveTimeout: DataSource.receiveTimeout,
      DioExceptionType.cancel: DataSource.cancel,
      DioExceptionType.connectionError: DataSource.connectionError,
    };

    return errorMap[error.type]?.getFailure() ??
        (error.type == DioExceptionType.badResponse
            ? _handleBadResponse(error)
            : _handleDefaultError(error));
  }

  Failure _handleBadResponse(DioException error) {
    try {
      final statusCode =
          error.response?.statusCode ?? ResponseCode.defaultError;

      final statusCodeMap = {
        ResponseCode.unauthorised: DataSource.unauthorised,
        ResponseCode.forbidden: DataSource.forbidden,
        ResponseCode.notFound: DataSource.notFound,
      };
      return statusCodeMap[statusCode]?.getFailure() ??
          Failure(
            code: statusCode,
            message: _extractErrorMessage(error.response?.data),
          );
    } catch (_) {
      return DataSource.defaultError.getFailure();
    }
  }

  Failure _handleDefaultError(DioException error) {
    return error.response?.statusCode == ResponseCode.noInternetConnection
        ? DataSource.noInternetConnection.getFailure()
        : DataSource.defaultError.getFailure();
  }

  String _extractErrorMessage(dynamic data) {
    if (data == null) return '';
    if (data is String) return data;
    if (data is! Map) return data.toString();

    return data.entries
        .map((entry) {
          final value = entry.value;
          if (value is List) return value.join('\n');
          return value.toString();
        })
        .where((message) => message.isNotEmpty)
        .join('\n');
  }
}

enum DataSource {
  success,
  noContent,
  badRequest,
  unauthorized,
  notFound,
  internetServerError,
  connectTimeout,
  connectionError,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultError,
  forbidden,
  unauthorised,
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    final context = navigatorKey!.currentState!.context;

    final failureMap = {
      DataSource.success: (ResponseCode.success, context.loc.success),
      DataSource.noContent: (ResponseCode.noContent, context.loc.noContent),
      DataSource.badRequest: (
        ResponseCode.badRequest,
        context.loc.badRequestError,
      ),
      DataSource.forbidden: (
        ResponseCode.forbidden,
        context.loc.forbiddenError,
      ),
      DataSource.unauthorised: (
        ResponseCode.unauthorised,
        context.loc.unauthorizedError,
      ),
      DataSource.notFound: (ResponseCode.notFound, context.loc.notFoundError),
      DataSource.internetServerError: (
        ResponseCode.internalServerError,
        context.loc.internalServerError,
      ),
      DataSource.connectTimeout: (
        ResponseCode.connectTimeout,
        context.loc.timeoutError,
      ),
      DataSource.connectionError: (
        ResponseCode.connectionError,
        ResponseMessage.connectionError,
      ),
      DataSource.cancel: (ResponseCode.cancel, ResponseMessage.cancel),
      DataSource.receiveTimeout: (
        ResponseCode.receiveTimeout,
        context.loc.timeoutError,
      ),
      DataSource.sendTimeout: (
        ResponseCode.sendTimeout,
        context.loc.timeoutError,
      ),
      DataSource.cacheError: (ResponseCode.cacheError, context.loc.cacheError),
      DataSource.noInternetConnection: (
        ResponseCode.noInternetConnection,
        context.loc.noInternetError,
      ),
      DataSource.defaultError: (
        ResponseCode.defaultError,
        context.loc.defaultError,
      ),
    };

    final (code, message) = failureMap[this]!;
    return Failure(code: code, message: message);
  }
}

class ResponseCode {
  const ResponseCode._();

  // API Status Codes
  static const int success = 200;
  static const int noContent = 201;
  static const int badRequest = 400;
  static const int unauthorised = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int invalidData = 422;
  static const int internalServerError = 500;

  // Local Status Codes
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int locationDenied = -7;
  static const int defaultError = -8;
  static const int connectionError = -9;
}

class ResponseMessage {
  const ResponseMessage._();

  // API Response Messages
  static const String success = AppStrings.strSuccess;
  static const String noContent = AppStrings.strNoContent;
  static const String badRequest = AppStrings.strBadRequestError;
  static const String unauthorised = AppStrings.strUnauthorizedError;
  static const String forbidden = AppStrings.strForbiddenError;
  static const String internalServerError = AppStrings.strInternalServerError;
  static const String notFound = AppStrings.strNotFoundError;

  // Local Response Messages
  static const String connectTimeout = AppStrings.strTimeoutError;
  static const String cancel = AppStrings.strDefaultError;
  static const String receiveTimeout = AppStrings.strTimeoutError;
  static const String sendTimeout = AppStrings.strTimeoutError;
  static const String cacheError = AppStrings.strCacheError;
  static const String noInternetConnection = AppStrings.strNoInternetError;
  static const String defaultError = AppStrings.strDefaultError;
  static const String connectionError = AppStrings.strDefaultError;
}

/// API internal status codes
class ApiInternalStatus {
  const ApiInternalStatus._();

  static const int success = 200;
  static const int failure = 400;
}
