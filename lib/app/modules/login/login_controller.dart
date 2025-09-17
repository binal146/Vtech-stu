import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/modules/login/model/LoginModel.dart';
import '../../core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/sharePrefrenceConst.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_controller.dart';


class LoginController extends BaseController {

  final ProjectRepository _repository =
  Get.find(tag: (ProjectRepository).toString());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isPasswordVisible = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }


  void signInService() {
    CommonUtils.getIntance().hidekeyboard(Get.context!);
    if (emailController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_email);
    }else if (!isValidEmail(emailController.text.trim())) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_valid_email);
    }else if (passwordController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_password);
    }else{
      callSigninService();
    }
  }

  // call signup service
  Future<void> callSigninService() async {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['email'] = emailController.value.text.trim();
      data['password'] = passwordController.value.text.trim();
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,signin,false);

    callDataService(
        apiService,
        onSuccess: successResponseSignin,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseSignin(dynamic baseResponse) async {

    LoginModel response = LoginModel.fromJson(baseResponse.data);

    if(response.success == true){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();sharedPreferences.setBool(SharePreferenceConst.isLogin, true);
      sharedPreferences.setString(SharePreferenceConst.token, response.data?.token ?? '');
      sharedPreferences.setInt(SharePreferenceConst.user_id, response.data?.userId ?? 0);
      sharedPreferences.setString(SharePreferenceConst.user_type, response.data?.userType ?? '');
      sharedPreferences.setString(SharePreferenceConst.full_name, response.data?.fullName ?? '');
      sharedPreferences.setString(SharePreferenceConst.profile_image, response.data?.profileImage ?? "");
      sharedPreferences.setInt(SharePreferenceConst.is_profile_approved, response.data?.profile_approved_app ?? 0);
      sharedPreferences.setInt(SharePreferenceConst.set_availability, response.data?.slot_availability ?? 0);
      sharedPreferences.setString(SharePreferenceConst.mobile_number, response.data?.mobileNumber ?? "");
      sharedPreferences.setString(SharePreferenceConst.email, response.data?.email ?? "");
      sharedPreferences.setInt(SharePreferenceConst.is_email_verified, response.data?.isEmailVerified ?? 0);
      sharedPreferences.setString(SharePreferenceConst.email_verified_at, response.data?.emailVerifiedAt ?? '');
      sharedPreferences.setInt(SharePreferenceConst.status, response.data?.status ?? 0);
      sharedPreferences.setString(SharePreferenceConst.created_at, response.data?.createdAt ?? '');
      sharedPreferences.setInt(SharePreferenceConst.notification_status, response.data?.notification_status ??  0);
      Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
    }else{

      if(response.code == "000"){
       showVerifyEmailDialog();
      }

      if(response.code == "111"){
        Fluttertoast.showToast(msg: response.response_msg!,
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

  bool isValidPassword(String password) {
    // Regular expression to check the password
    String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\W).+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  void showVerifyEmailDialog() {
    showDialog<String>(
        context: Get.context!,
        builder: (BuildContext context) => AlertDialog(
          title:  Text(AppText.verify_email,style: TextStyle(fontSize: 14.sp,fontFamily: Fonts.PoppinsMedium,color: Clr.black),),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(AppText.verify_email_msg,style:TextStyle(fontSize: 12.sp,fontFamily: Fonts.PoppinsMedium,color: Clr.greyColor) ,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(AppText.verify_now),
              onPressed: () async {
                callEmailVerificationService();
                Get.back();
              },
            ),
            TextButton(
              child:  Text(AppText.not_now),
              onPressed: () {
                Get.back();
              },
            )
          ],
        ));
  }

  Future<void> callEmailVerificationService() async {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['email'] = emailController.value.text.trim();
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,send_verification_email,false);

    callDataService(
        apiService,
        onSuccess: successResponseEmailVerification,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseEmailVerification(dynamic baseResponse) async {

    BaseModel response = BaseModel.fromJson(baseResponse.data);

    if(response.success == true) {
      Fluttertoast.showToast(msg: response.response_msg!,
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


