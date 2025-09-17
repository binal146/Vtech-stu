import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:vteach_teacher/app/core/utils/api_services.dart';
import '../../core/base/BaseModel.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/values/comman_text.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '/app/core/base/base_controller.dart';

class ForgotPasswordController extends BaseController {

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());
  final emailController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void forgotPassword() {
    CommonUtils.getIntance().hidekeyboard(Get.context!);
    if (emailController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_email);
    }else if(!isValidEmail(emailController.text.trim())) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_valid_email);
    }else{
      callForgotPasswordService();
    }
  }

  // call forgot_password service
  void callForgotPasswordService(){
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['email'] = emailController.value.text.trim();

      return data;
    }

    var forgotPasswordService = _repository.sendPostApiRequest(toJson,forgot_password,false);

    callDataService(
        forgotPasswordService,
        onSuccess: successResponseForgotPassword,
        onError: handleOnError,
      isShowLoading: true,
    );
  }

  // success response forgot_password service
  Future<void> successResponseForgotPassword(dynamic response) async {

    BaseModel baseResponse = BaseModel.fromJson(response.data);

    Fluttertoast.showToast(
        msg: baseResponse.response_msg.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Clr.primaryColor,
        textColor: Clr.white,
        fontSize: 16.0
    );

    if(baseResponse.success == true){
      Get.back();
    }

    }

  // error response manage here
  void handleOnError(dynamic e) {
    if(e is ApiException){

      Fluttertoast.showToast(
          msg: e.response_msg,
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

}
