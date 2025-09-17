
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/values/comman_text.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '/app/core/base/base_controller.dart';

class SignUp2Controller extends BaseController {

  final ProjectRepository _repository =
  Get.find(tag: (ProjectRepository).toString());

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isCheck = false.obs;

  Rx<Country> selectedDialogCountry = CountryPickerUtils.getCountryByPhoneCode('91').obs;

  RxBool isPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;
  late SharedPreferences sharedPreferences;
  late int isVerificationMode;
  late String storeCountryCode;
  String languageCode = "en";


  var textfieldControllers = <TextEditingController>[].obs;
  final List<GlobalKey<FormState>> formKeys = [];
  var images = <XFile?>[].obs;


  final ImagePicker picker = ImagePicker();

  late Map<String, dynamic> parameters;

  @override
  Future<void> onInit() async {
    super.onInit();
    addTextField();
    parameters =  Get.arguments;
     sharedPreferences = await SharedPreferences.getInstance();
  }


  @override
  void dispose() {
    for (var controller in textfieldControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addTextField() {
    textfieldControllers.add(TextEditingController());
    formKeys.add(GlobalKey<FormState>());
    images.add(null);
  }

  Future<void> pickImage(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
        images[index] = XFile(pickedFile.path);
    }
  }

  Future<void> pickPdf(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      images[index] = XFile(result.files.single.path!);
    } else {
      // User canceled the picker
    }
  }


  void signUpService() {
    CommonUtils.getIntance().hidekeyboard(Get.context!);
    if(validateAll() == true){
    if(isCheck == false) {
      CommonUtils.getIntance().toastMessage(AppText.please_accept_terms_condition_privacy_policy);
    }else{
      callSignupService();
    }
  }else{
      CommonUtils.getIntance().toastMessage(AppText.document_title_attachment_cannot_be_blank);
    }
  }

  // call signup service
  Future<void> callSignupService() async {
    List<String> titleArray = [];
    for(int i=0;i<textfieldControllers.length;i++){
      titleArray.add(textfieldControllers[i].value.text.toString());
    }

    List<MultipartFile> files = [];
    for (var image in images) {
      files.add(await MultipartFile.fromFile(image!.path, filename: image.name));
    }

    parameters['document_files[]'] = files;

    parameters['document_titles'] = titleArray.join(',');
    var apiService = _repository.sendMultipartApiRequest(parameters,signup,false);

    callDataService(
        apiService,
        onSuccess: successResponseSignup,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseSignup(dynamic baseResponse) async {

     BaseModel response = BaseModel.fromJson(baseResponse.data);

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

  bool isValidPassword(String password) {
    // Regular expression to check the password
    String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\W).+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  bool validateAll() {
    bool isValid = true;
    for (final controller in textfieldControllers) {
      if (controller.text.isEmpty) {
        isValid = false;
      }
    }

    for (final image in images) {
      if (image == null) {
        isValid = false;
        break;
      }
    }
    return isValid;
  }


}
