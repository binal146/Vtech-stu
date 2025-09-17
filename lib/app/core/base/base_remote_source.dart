import 'dart:io';

import 'package:dio/dio.dart';
import '../../network/dio_provider.dart';
import '../../network/error_handlers.dart';
import '../../network/exceptions/base_exception.dart';
import '/flavors/build_config.dart';

abstract class BaseRemoteSource {
  Dio get dioClient => DioProvider.dioWithHeaderToken;

  final logger = BuildConfig.instance.config.logger;

  Future<Response<T>> callApiWithErrorParser<T>(Future<Response<T>> api) async {

    try {
      Response<T> response = await api;

      if (response.statusCode != HttpStatus.ok ||
          (response.data as Map<String, dynamic>)['statusCode'] !=
              HttpStatus.ok) {
        // TODO
      }

      return response;
    } on DioError catch (dioError) {
      Exception exception = handleDioError(dioError);
      logger.e("Throwing error from repository: >>>>>>> $exception : ${(exception as BaseException).response_msg}");
      throw exception;
    } catch (error) {
      logger.e("Generic error: >>>>>>> $error");

      if (error is BaseException) {
        rethrow;
      }
      Response<T> response = await api;
      throw handleError("$error",response.statusCode!);
    }
  }
}
