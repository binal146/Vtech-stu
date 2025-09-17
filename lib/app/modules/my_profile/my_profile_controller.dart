import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/modules/my_profile/model/MyProfileModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/values/sharePrefrenceConst.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '/app/core/base/base_controller.dart';
import 'model/MyProfileData.dart';

class MyProfileController extends BaseController {

  TextEditingController searchContoller = TextEditingController();

  final ProjectRepository _repository =
  Get.find(tag: (ProjectRepository).toString());

  String userId = "";

  late var myProfileData = Rxn<MyProfileData>();

  @override
  Future<void> onInit() async {
    super.onInit();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getInt(SharePreferenceConst.user_id).toString();
    callGetProfileService();
  }

  // call signup service
  Future<void> callGetProfileService() async {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['user_id'] = userId;
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,get_profile,false);

    callDataService(
        apiService,
        onSuccess: successResponseGetProfile,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseGetProfile(dynamic baseResponse) async {

    MyProfileModel response = MyProfileModel.fromJson(baseResponse.data);

    if(response.success == true){
      myProfileData.value = response.data;
    }
  }

  // error response manage here
  void handleOnError(dynamic e) {
    if(e is ApiException){
      Fluttertoast.showToast(msg: e.response_msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Clr.primaryColor,
          textColor: Clr.white,
          fontSize: 16.0
      );
    }

  }




}


