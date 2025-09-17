import 'dart:io';

import '/app/network/exceptions/api_exception.dart';

class NotFoundException extends ApiException {
  NotFoundException(String message, String status,
      bool sucess)
      : super(httpCode: HttpStatus.notFound,sucess: sucess, screen_code: status, message: message);
}
