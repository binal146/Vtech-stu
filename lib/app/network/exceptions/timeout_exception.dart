import '/app/network/exceptions/base_exception.dart';

class TimeoutException extends BaseException {
  TimeoutException(String message) : super(response_msg: message);
}
