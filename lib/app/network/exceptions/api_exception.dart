import '/app/network/exceptions/base_api_exception.dart';

class ApiException extends BaseApiException {
  ApiException({
    required int httpCode,
    required bool sucess,
    required String screen_code,
    String message = "",
  }) : super(httpCode: httpCode, sucess:sucess,screen_code: screen_code, message: message);
}
