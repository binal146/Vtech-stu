import '/app/network/exceptions/base_exception.dart';

class JsonFormatException extends BaseException {
  JsonFormatException(String message) : super(response_msg: message);
}
