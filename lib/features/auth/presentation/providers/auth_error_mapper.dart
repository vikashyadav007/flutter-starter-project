import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/core/api/error_handler.dart';

Failure mapLoginFailure(Failure failure) {
  switch (failure.code) {
    case ResponseCode.unauthorised:
      return Failure(
        code: failure.code,
        message:
            'The email or password you entered is incorrect. Please try again.',
      );
    case ResponseCode.connectionError:
      return Failure(
        code: failure.code,
        message:
            'No internet connection. Please check your connection and try again.',
      );
    default:
      return Failure(
        code: ResponseCode.defaultError,
        message: 'Failed to login. Please try again later.',
      );
  }
}
