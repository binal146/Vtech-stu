import '/app/network/exceptions/base_exception.dart';

class AppException extends BaseException {
  AppException({
    required int httpCode,
    String response_msg = "",
  }) : super(httpCode: httpCode,response_msg: response_msg);
}


