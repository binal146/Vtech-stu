
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProjectRemoteDataSource {


  Future<dynamic> sendPostApiRequest(
      Map<String, dynamic> Function() toJson,String apiname,bool isToken);

  Future<dynamic> sendGetApiWithParamRequest(
      Map<String, dynamic> Function() toJson,String apiname,bool isToken);

  Future<dynamic> sendGetApiNoParamRequest(String apiname);

  Future<dynamic> sendMultipartApiRequest(
      Map<String, dynamic>  toJson,
      String apiName,
      bool isToken);


}
