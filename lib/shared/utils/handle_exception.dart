// Project imports:

import 'package:starter_project/core/api/error_handler.dart';
import 'package:starter_project/core/api/failure.dart';

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
