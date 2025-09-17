import '/app/network/exceptions/app_exception.dart';

abstract class BaseApiException extends AppException {
  @override
  final int httpCode;
  final bool sucess;
  final String screen_code;

  BaseApiException({this.httpCode = -1,this.sucess = false, this.screen_code = "", String message = ""})
      : super(httpCode: httpCode,response_msg: message);
}
