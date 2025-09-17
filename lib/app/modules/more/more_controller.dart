import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/core/base/BaseModel.dart';
import 'package:vteach_teacher/app/core/utils/common_widgets.dart';
import 'package:vteach_teacher/app/core/values/sharePrefrenceConst.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_controller.dart';

class MoreController extends BaseController {

  TextEditingController searchContoller = TextEditingController();

  final ProjectRepository _repository =
  Get.find(tag: (ProjectRepository).toString());

  RxBool isToggleOn = false.obs;
  RxInt setAvailability = 0.obs;
  RxInt notificationStatus = 0.obs;
  String userId = "";
  late SharedPreferences sharedPreferences;

  @override
  Future<void> onInit() async {
    super.onInit();
    sharedPreferences = await SharedPreferences.getInstance();
    setAvailability.value = sharedPreferences.getInt(SharePreferenceConst.set_availability) ?? 0;
    notificationStatus.value = sharedPreferences.getInt(SharePreferenceConst.notification_status) ?? 0;
    userId = sharedPreferences.getInt(SharePreferenceConst.user_id).toString();
    if(notificationStatus.value == 1){
      isToggleOn.value = true;
    }else{
      isToggleOn.value = false;
    }
  }

  // call signup service
  Future<void> callLogoutService() async {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,logout,false);

    callDataService(
        apiService,
        onSuccess: successResponseLogout,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseLogout(dynamic baseResponse) async {
    BaseModel response = BaseModel.fromJson(baseResponse.data);
    if(response.success == true){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.clear();
      Get.offAllNamed(Routes.LOGIN);
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


  // call signup service
  Future<void> callNotificationStatusService(String status) async {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['notification_status'] = status;
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,notification_status,false);

    callDataService(
        apiService,
        onSuccess: successResponseNotification,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseNotification(dynamic baseResponse) async {
    BaseModel response = BaseModel.fromJson(baseResponse.data);
    CommonUtils.getIntance().toastMessage(response.response_msg.toString());
    if(response.success == true){
      isToggleOn.value = !isToggleOn.value;
      sharedPreferences.setInt(SharePreferenceConst.notification_status, isToggleOn.value ? 1 : 0);
    }
  }

}


