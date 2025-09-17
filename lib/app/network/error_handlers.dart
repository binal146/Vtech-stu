import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:vteach_teacher/app/network/exceptions/unauthorize_exception.dart';
import '/app/network/exceptions/api_exception.dart';
import '/app/network/exceptions/app_exception.dart';
import '/app/network/exceptions/network_exception.dart';
import '/app/network/exceptions/not_found_exception.dart';
import '/app/network/exceptions/service_unavailable_exception.dart';
import '/flavors/build_config.dart';

Exception handleError(String error,int httpCode) {
  final logger = BuildConfig.instance.config.logger;
  logger.e("Generic exception: $error");

  return AppException(httpCode:httpCode,response_msg: error);
}

Exception handleDioError(DioError dioError) {
  switch (dioError.type) {
    case DioErrorType.cancel:
      return AppException(httpCode: dioError.response?.statusCode ?? -1,response_msg: "Request to API server was cancelled");
    case DioErrorType.connectTimeout:
      return AppException(httpCode:dioError.response?.statusCode ?? -1,response_msg: "Connection timeout with API server");
    case DioErrorType.other:
      return NetworkException("There is no internet connection");
    case DioErrorType.receiveTimeout:
      return TimeoutException("Receive timeout in connection with API server");
    case DioErrorType.sendTimeout:
      return TimeoutException("Send timeout in connection with API server");
    case DioErrorType.response:
      return _parseDioErrorResponse(dioError);
  }
}



Exception _parseDioErrorResponse(DioError dioError) {
  final logger = BuildConfig.instance.config.logger;

  int statusCode = dioError.response?.statusCode ?? -1;
  bool? sucess;
  String? status;
  String? serverMessage;

  try {
    if (statusCode == -1 || statusCode == HttpStatus.ok) {
      statusCode = dioError.response?.data["statusCode"];
    }
    sucess = dioError.response?.data["success"];
    serverMessage = dioError.response?.data["response_msg"];
  } catch (e) {
   // logger.i("$e");
   // logger.i(s.toString());

     serverMessage = "Something went wrong. Please try again later.";
  }

  switch (statusCode) {
    case HttpStatus.serviceUnavailable:
      return ServiceUnavailableException("Service Temporarily Unavailable");
    case HttpStatus.notFound:
      return NotFoundException(serverMessage ?? "", "",sucess ?? false);
    case HttpStatus.unauthorized:
      return UnauthorizedException(serverMessage ?? "User has logged in on another device.");
    default:
      return ApiException(
          httpCode: statusCode,
          sucess: sucess ?? false,
          screen_code: status ?? "",
          message: serverMessage ?? "");
  }
}
