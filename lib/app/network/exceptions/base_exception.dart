abstract class BaseException implements Exception {
  final String response_msg;
  final int httpCode;
  BaseException({this.httpCode = -1,this.response_msg = ""});
}
