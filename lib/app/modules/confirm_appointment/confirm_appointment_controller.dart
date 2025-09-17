import 'package:flutter/cupertino.dart';
import 'package:get/instance_manager.dart';
import '../../data/repository/project_repository.dart';
import '/app/core/base/base_controller.dart';

class ConfirmAppointmentController extends BaseController {

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());
  final emailController = TextEditingController();



  @override
  Future<void> onInit() async {
    super.onInit();
  }


/*  void forgotPassword() {
    if (emailController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(LocaleKeys.please_enter_email.tr());
    }else if(isMobile.value == true){
      if(emailController.text.trim().length < 10 || emailController.text.trim().length > 10){
        CommonUtils.getIntance().toastMessage(LocaleKeys.please_enter_valid_mobile.tr());
      }else{
        checkUserMobile();
      }
    }else if(!isValidEmail(emailController.text.trim())) {
      CommonUtils.getIntance().toastMessage(LocaleKeys.please_enter_valid_email.tr());
    }else{
      callForgotPasswordService();
    }
  }

  // call forgot_password service
  void callForgotPasswordService(){
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['app_token'] = Constants.app_token;
      if(emailController.value.text.trim().contains("@")){
        data['email'] = emailController.value.text.trim();
      }else{
        data['mobile'] = emailController.value.text.trim();
      }

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

    LoginModel baseResponse = LoginModel.fromJson(response.data);

    if(baseResponse.success == true){
      if(isMobile.value){
        Get.toNamed(Routes.SET_PASSWORD, parameters: {'email': emailController.value.text.trim()});
      }else{

        Fluttertoast.showToast(
            msg: baseResponse.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Clr.primaryColor,
            textColor: Clr.white,
            fontSize: 16.0
        );

        Get.toNamed(Routes.OTP,parameters: {'email_mobile' : emailController.value.text.trim(),'from' : "0", 'id':baseResponse.id.toString()} );
      }
    }

  }

  // error response manage here
  void handleOnError(dynamic e) {
    if(e is ApiException){

      Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Clr.primaryColor,
          textColor: Clr.white,
          fontSize: 16.0
      );
    }

*//*    if(e is NetworkException){
      CommonUtils.commonUtils?.toastMessage(e.message);
    }*//*
  }


  bool isValidEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }*/

}
