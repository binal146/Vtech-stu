import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/colour.dart';
import '../../core/values/sharePrefrenceConst.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/base_exception.dart';
import '/app/core/base/base_controller.dart';

class RateReviewController extends BaseController {

  final ProjectRepository _repository =
  Get.find(tag: (ProjectRepository).toString());

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isCheck = false.obs;

  Rx<Country> selectedDialogCountry = CountryPickerUtils.getCountryByPhoneCode('').obs;

  RxBool isPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;
  late SharedPreferences sharedPreferences;
  late int isVerificationMode;
  late String storeCountryCode;
  String languageCode = "en";

  RxDouble rating = 3.0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
     sharedPreferences = await SharedPreferences.getInstance();
     selectedDialogCountry.value = CountryPickerUtils.getCountryByPhoneCode(storeCountryCode.replaceAll("+", ''));
  }

  /*void signUpService() {
    if(fullNameController.text.trim().isEmpty){
      CommonUtils.getIntance().toastMessage(LocaleKeys.please_enter_your_name.tr());
    }else if (emailController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(LocaleKeys.please_enter_valid_email.tr());
    }else if (!isValidEmail(emailController.text.trim())) {
      CommonUtils.getIntance().toastMessage(LocaleKeys.please_enter_valid_email.tr());
    } else if (mobileController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(LocaleKeys.please_enter_phone_number.tr());
    }else if (passwordController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(LocaleKeys.please_enter_password.tr());
    }else if (confirmPasswordController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(LocaleKeys.please_enter_confirm_password.tr());
    }else if (confirmPasswordController.text.trim().toString() != passwordController.text.trim().toString()) {
      CommonUtils.getIntance().toastMessage(LocaleKeys.password_confirm_password_not_matched.tr());
    }else if(isCheck.value == false){
      CommonUtils.getIntance().toastMessage(LocaleKeys.please_accept_terms_condition_privacy_policy.tr());
    }else{
      callSignupService();
    }
  }*/

/*  // call signup service
  Future<void> callSignupService() async {


    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['app_token'] = Constants.app_token;
      data['customer_name'] = fullNameController.value.text.trim();
      data['email'] = emailController.value.text.trim();
      data['mobile'] = mobileController.value.text.trim();
      data['password'] = passwordController.value.text.trim();
      data['confirm_password'] = confirmPasswordController.value.text.trim();
      data['is_mobile_verified'] = isVerificationMode.toString();
      return data;
    }

    var loginService = _repository.sendPostApiRequest(toJson,signup,false);

    callDataService(
        loginService,
        onSuccess: successResponseSignup,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseSignup(dynamic baseResponse) async {

    LoginModel response = LoginModel.fromJson(baseResponse.data);

    if(response.screenCode == Constants.SUCCESS_CODE){

      if(isVerificationMode == 1){
        Get.toNamed(Routes.OTP,parameters: {'email_mobile' : mobileController.text.toString().trim(),'from' : "1",'id' : response.id.toString() } );
      }else{
        Fluttertoast.showToast(msg: response.message!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Clr.primaryColor,
            textColor: Clr.white,
            fontSize: 16.0
        );
        Get.toNamed(Routes.OTP,parameters: {'email_mobile' : emailController.text.toString().trim(),'from' : "1" ,'id': response.id.toString()} );
      }

    }

  }*/

  // error response manage here
  void handleOnError(dynamic e) {
    if(e is BaseException) {
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

}
