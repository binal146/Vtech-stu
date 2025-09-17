import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/values/comman_text.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_controller.dart';

class ChangePasswordController extends BaseController {

  final ProjectRepository _repository =
  Get.find(tag: (ProjectRepository).toString());

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  RxBool isPasswordVisible = true.obs;
  RxBool isNewPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void changePasswordService() {
    CommonUtils.getIntance().hidekeyboard(Get.context!);
    if(oldPasswordController.text.trim().isEmpty){
      CommonUtils.getIntance().toastMessage(AppText.please_enter_old_password);
    }else if (newPasswordController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_new_password);
    } else if(confirmNewPasswordController.text.trim().isEmpty){
      CommonUtils.getIntance().toastMessage(AppText.please_enter_confirm_password);
    }else{
      callChangePasswordService();
    }
  }

  // call signup service
  Future<void> callChangePasswordService() async {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['old_password'] = oldPasswordController.value.text.trim();
      data['password'] = newPasswordController.value.text.trim();
      data['confirm_password'] = confirmNewPasswordController.value.text.trim();
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,change_password,false);

    callDataService(
        apiService,
        onSuccess: successResponseChangePassword,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseChangePassword(dynamic baseResponse) async {

    BaseModel response = BaseModel.fromJson(baseResponse.data);

    Fluttertoast.showToast(msg: response.response_msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Clr.primaryColor,
        textColor: Clr.white,
        fontSize: 16.0
    );

    if(response.success == true){
    //  Get.back();
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.clear();
      Get.offAllNamed(Routes.LOGIN);
    }else{
      if(response.response_msg == "Old password invalid"){
        oldPasswordController.text = "";
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

  bool isValidPassword(String password) {
    // Regular expression to check the password
    String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\W).+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }
}
