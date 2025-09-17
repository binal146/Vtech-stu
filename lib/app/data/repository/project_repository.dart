import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProjectRepository{

  Future<dynamic> sendPostApiRequest(Map<String, dynamic> Function() toJson,String apiName,bool isToken);

  Future<dynamic> sendGetApiWithParamRequest(Map<String, dynamic> Function() toJson,String apiName,bool isToken);

  Future<dynamic> sendMultipartApiRequest(Map<String, dynamic> toJson,
      String apiName,
      bool isToken);


  Future<dynamic> sendGetApiNoParamRequest(String apiname);

}