// Project imports:

import 'package:fuel_pro_360/core/api/error_handler.dart';
import 'package:fuel_pro_360/core/api/failure.dart';

Failure handleException({required Object exception, String? message}) {
  // TODO: Implement exception handling

  if (message != null)
    return Failure(code: ResponseCode.defaultError, message: message);

  return Failure(
    code: ResponseCode.defaultError,
    message:
        'We\'re having trouble processing your request. Please try again later.',
  );
}
