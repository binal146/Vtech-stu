import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/instance_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';
import '../../core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/sharePrefrenceConst.dart';
import '../../core/values/text_styles.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../../routes/app_pages.dart';
import '../NotificationPayloadModel.dart';
import '../bottom__navigation_bar/BottomNavController.dart';
import '../login/model/LoginModel.dart';
import '/app/core/base/base_controller.dart';

class CallController extends BaseController {

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());
  final emailController = TextEditingController();


  //late NotificationPayloadModel notificationModel;
  String notificationPayload = "";
  RxString callerName = "".obs;
  String apiStatus = "";
  late NotificationPayloadModel notificationModel;

  final BottomNavController bottomNavController = Get.put(BottomNavController(), permanent: false);

  @override
  Future<void> onInit() async {
    super.onInit();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    notificationPayload = sharedPreferences.getString(SharePreferenceConst.notification_payload)!;
    var valueMap = convertPayloadNew(notificationPayload);
    notificationModel = NotificationPayloadModel.fromJson(valueMap);
    callerName.value = notificationModel.full_name.toString();
  }


  void forgotPasswordService() {
    if (emailController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_email);
    }else if (!isValidEmail(emailController.text.trim())) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_valid_email);
    }else{
      callForgotPasswordService();
    }
  }

  // call signup service
  Future<void> callForgotPasswordService() async {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['email'] = emailController.value.text.trim();
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,forgot_password,false);

    callDataService(
        apiService,
        onSuccess: successForgotPassword,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successForgotPassword(dynamic baseResponse) async {

    LoginModel response = LoginModel.fromJson(baseResponse.data);

    Fluttertoast.showToast(msg: response.response_msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Clr.primaryColor,
        textColor: Clr.white,
        fontSize: 16.0
    );

    if(response.success == true) {
     Get.back();
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

  bool isValidEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  void closeScreen() {
    Get.back();
  }

  Future<void> checkPermissions() async {
    bool cameraGranted = await requestCameraPermission();
    bool microphoneGranted = await requestMicrophonePermission();
    if (cameraGranted && microphoneGranted) {
    /*  bottomNavController.callActionVCallService('accept',"");
      Get.offNamed(Routes.AGORA_DEMO_NEW,arguments: notificationModel);*/
       callActionVCallService('accept',"");
    } else {
      openSettingScreen();
    }
  }

  Future<bool> requestCameraPermission() async {
    return await requestPermission(Permission.camera);
  }

  Future<bool> requestMicrophonePermission() async {
    return await requestPermission(Permission.microphone);
  }

  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      // Permission already granted
      return true;
    } else {
      // Request permission
      final result = await permission.request();

      if (result.isGranted) {
        // Permission granted
        return true;
      } else {
        // Permission denied
        return false;
      }
    }
  }

  void openSettingScreen() {
    showDialog<String>(
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppText.permission, style: blackPoppinsSemiBold20),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(AppText.need_to_give_permission, style: blackPoppinsRegular18),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppText.open_setting),
            onPressed: () async {
              bottomNavController.callActionVCallService('decline',"");
              Get.back();
              Get.back();
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  Future<void> callActionVCallService(String status,String callDuration) async {
    apiStatus = status;
    print("notificationModel!.booking_id.toString()" +
        bottomNavController.notificationModel!.booking_id.toString());
    print("notificationModel!.booking_slot_id.toString()" +
        bottomNavController.notificationModel!.booking_slot_id.toString());
    print("notificationModel!.channel_id.toString()" +
        bottomNavController.notificationModel!.channel_id.toString());
    print("notificationModel!.app_unique_call_id.toString()" +
        bottomNavController.notificationModel!.app_unique_call_id.toString());

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['action_status'] = status;
      data['booking_id'] = bottomNavController.notificationModel!.booking_id.toString();
      data['booking_slot_id'] = bottomNavController.notificationModel!.booking_slot_id.toString();
      data['channel_id'] = bottomNavController.notificationModel!.channel_id.toString();
      data['app_unique_call_id'] = bottomNavController.notificationModel!.app_unique_call_id.toString();
      if(status == "call_end"){
        data['call_duration'] = callDuration;
      }
      return data;
    }

    var apiService = _repository.sendPostApiRequest(
        toJson, action_vcall_notification, false);

    callDataService(
      apiService,
      onSuccess: successResponse,
      onError: handleOnError,
      isShowLoading: true,
    );
  }

  Future<void> successResponse(dynamic baseResponse) async {
    BaseModel response = BaseModel.fromJson(baseResponse.data);
    if (response.success == true) {
      if(apiStatus == "accept"){
        Get.offNamed(Routes.AGORA_DEMO_NEW,arguments: notificationModel);
      }else{
        Get.back();
      }
    }
  }
}
