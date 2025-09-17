import 'package:dio/dio.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/api_services.dart';
import '../../core/values/constants.dart';
import '../../core/values/sharePrefrenceConst.dart';
import '/app/core/base/base_remote_source.dart';
import 'project_remote_data_source.dart';

class ProjectRemoteDataSourceImpl extends BaseRemoteSource implements ProjectRemoteDataSource {

  @override
  Future sendPostApiRequest(Map<String, dynamic> Function() toJson,
      String apiName, bool isToken) async {

    String baseUrl = "";
    if(Constants.isProduction){
      baseUrl = baseUrlProd;
    }else{
      baseUrl = baseUrlDev;
    }

    var endpoint = "$baseUrl$apiName";

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(SharePreferenceConst.token);

    bool? isLogin = false;
    if (sharedPreferences.getBool(SharePreferenceConst.isLogin) != null) {
      isLogin = sharedPreferences.getBool(SharePreferenceConst.isLogin);
    }
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    dioClient.options.headers["timezone"] = currentTimeZone;
    if (token != null && token.isNotEmpty) {
      dioClient.options.headers["Authorization"] = "Bearer $token";
    }


    var dioCall = dioClient.post(endpoint, data: FormData.fromMap(toJson.call()));
    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => _parseApiResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future sendGetApiRequest(Map<String, dynamic> Function() toJson,
      String apiName) async {

    String baseUrl = "";

    if(Constants.isProduction){
      baseUrl = baseUrlProd;
    }else{
      baseUrl = baseUrlDev;
    }

    var endpoint = "$baseUrl$apiName";


    var dioCall = dioClient.post(endpoint, queryParameters: toJson());
    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => _parseApiResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  dynamic _parseApiResponse(Response<dynamic> response) {
    return response;
  }

  @override
  Future sendGetApiNoParamRequest(String apiName) async {

    String baseUrl = "";

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString(SharePreferenceConst.token);

    if(Constants.isProduction){
      baseUrl = baseUrlProd;
    }else{
      baseUrl = baseUrlDev;
    }
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    if (token != null && token.isNotEmpty) {
      dioClient.options.headers["Authorization"] = "Bearer $token";
    }
    dioClient.options.headers["timezone"] = currentTimeZone;
    var endpoint = "$baseUrl$apiName";
    dioClient.options.headers['accept'] = "application/json";
    var dioCall = dioClient.get(endpoint);
    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => _parseApiResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future sendGetApiWithParamRequest(Map<String, dynamic> Function() toJson,
      String apiName, bool isToken)
  async {

    String baseUrl = "";

    if(Constants.isProduction){
      baseUrl = baseUrlProd;
    }else{
      baseUrl = baseUrlDev;
    }

    var endpoint = "$baseUrl$apiName";

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(
        SharePreferenceConst.token);

    bool? isLogin = false;
    if (sharedPreferences.getBool(SharePreferenceConst.isLogin) != null) {
      isLogin = sharedPreferences.getBool(SharePreferenceConst.isLogin);
    }

    if (token != null && token.isNotEmpty) {
      dioClient.options.headers["Authorization"] = "Bearer $token";
    }

      var dioCall = dioClient.get(endpoint, queryParameters: toJson());
      try {
        return callApiWithErrorParser(dioCall).then((response) =>
            _parseApiResponse(response));
      } catch (e) {
        rethrow;
      }
    }


  Future sendMultipartApiRequest(
      Map<String, dynamic>  toJson,
      String apiName,
      bool isToken
      ) async {
    String baseUrl = "";
    if(Constants.isProduction){
      baseUrl = baseUrlProd;
    }else{
      baseUrl = baseUrlDev;
    }

    var endpoint = "$baseUrl$apiName";

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(SharePreferenceConst.token);

    bool? isLogin = false;
    if (sharedPreferences.getBool(SharePreferenceConst.isLogin) != null) {
      isLogin = sharedPreferences.getBool(SharePreferenceConst.isLogin);
    }
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    dioClient.options.headers["timezone"] = currentTimeZone;
    if (token != null && token.isNotEmpty) {
      dioClient.options.headers["Authorization"] = "Bearer $token";
    }
    // Create form data
    var formData = FormData.fromMap(toJson);

    var dioCall = dioClient.post(endpoint, data: formData);
    try {
      return callApiWithErrorParser(dioCall)
          .then((response) => _parseApiResponse(response));
    } catch (e) {
      rethrow;
    }
  }

}


