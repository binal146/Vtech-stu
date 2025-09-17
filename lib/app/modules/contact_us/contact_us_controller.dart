import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/sharePrefrenceConst.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/base_exception.dart';
import '../signup_1/model/CountryData.dart';
import '../signup_1/model/CountryModel.dart';
import '/app/core/base/base_controller.dart';

class ContactUsController extends BaseController {

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final messageController = TextEditingController();

  RxList<CountryData> countryList = <CountryData>[].obs;

  RxString countryCode = ''.obs;
  RxString isoCode = ''.obs;
  RxString outletsSelectedName = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    fullNameController.text = sharedPreferences.getString(SharePreferenceConst.full_name).toString();
    emailController.text = sharedPreferences.getString(SharePreferenceConst.email).toString();
    mobileController.text = sharedPreferences.getString(SharePreferenceConst.mobile_number).toString();
    callCountryListService();
  }

  void contactUsService() {
    if(fullNameController.text.trim().isEmpty){
      CommonUtils.getIntance().toastMessage(AppText.please_enter_your_name);
    }else if (emailController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_email);
    }else if (!isValidEmail(emailController.text.trim())) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_valid_email);
    } else if (mobileController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_mobile_number);
    } else if (mobileController.text.trim().length < 7 || mobileController.text.trim().length > 15) {
      CommonUtils.getIntance().toastMessage(AppText.mobile_number_validation);
    }else if (messageController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_message);
    }else{
      callContactUsService();
    }
  }

  Future<void> callContactUsService() async {

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['name'] = fullNameController.value.text.trim();
      data['email'] = emailController.value.text.trim();
      data['mobile_number'] = mobileController.value.text.trim();
      data['country_code'] = countryCode.value.toString();
      data['iso_code'] = isoCode.value.toString();
      data['message'] = messageController.value.text.trim();
      return data;
    }

    var service = _repository.sendPostApiRequest(toJson,contact_us,false);
    callDataService(
        service,
        onSuccess: successResponseContactUs,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseContactUs(dynamic baseResponse) async {

    BaseModel response = BaseModel.fromJson(baseResponse.data);
    Fluttertoast.showToast(msg: response.response_msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Clr.primaryColor,
        textColor: Clr.white,
        fontSize: 16.0
    );

    if(response.success == true){
      Get.back();
    }
  }

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

  // call grade_list service
  Future<void> callCountryListService() async {

    var apiService = _repository.sendGetApiNoParamRequest(country_list);

    callDataService(
        apiService,
        onSuccess: successResponseCountryList,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseCountryList(dynamic baseResponse) async {
    CountryModel response = CountryModel.fromJson(baseResponse.data);
    if(response.success == true){
      countryList.addAll(response.data!);
      countryCode.value = countryList[0].phonecode.toString();
      isoCode.value = countryList[0].iso_code.toString();
    }
  }

}
