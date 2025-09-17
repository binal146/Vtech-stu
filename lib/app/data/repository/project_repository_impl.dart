import 'package:dio/dio.dart' as FormData;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../remote/project_remote_data_source.dart';
import 'project_repository.dart';

class ProjectRepositoryImpl extends ProjectRepository{

  final ProjectRemoteDataSource _remoteSource =
  Get.find(tag: (ProjectRemoteDataSource).toString());


  @override
  Future<dynamic> sendPostApiRequest(Map<String, dynamic> Function() toJson,String apiname,bool isToken) {
    return _remoteSource.sendPostApiRequest(toJson,apiname,isToken);
  }

  @override
  Future<dynamic> sendMultipartApiRequest(Map<String, dynamic> toJson, String apiName, bool isToken) {
    return _remoteSource.sendMultipartApiRequest(toJson,apiName,isToken);
  }



  @override
  Future sendGetApiNoParamRequest(String apiname) {
    return _remoteSource.sendGetApiNoParamRequest(apiname);
  }

  @override
  Future sendGetApiWithParamRequest(Map<String, dynamic> Function() toJson, String apiname,bool isToken) {
    return _remoteSource.sendGetApiWithParamRequest(toJson,apiname,isToken);
  }

}