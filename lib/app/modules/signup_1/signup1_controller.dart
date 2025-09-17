import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/CountryData.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/CountryModel.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/GradesData.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/StateData.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/StateModel.dart';
import '../../core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/values/comman_text.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../../routes/app_pages.dart';
import '../GradeSubjectModelNew.dart';
import '/app/core/base/base_controller.dart';
import 'model/GradesModel.dart';
import 'model/SignUpModel.dart';
import 'model/SubjectDataNew.dart';
import 'model/SubjectModelNew.dart';

class SignUp1Controller extends BaseController {

  final ProjectRepository _repository =
  Get.find(tag: (ProjectRepository).toString());

  final teacherNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final experienceController = TextEditingController();
  final educationBackgroundController = TextEditingController();
  final interestController = TextEditingController();
  final spokenLangaugesController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final descriptionController = TextEditingController();
  final ratePerHoursController = TextEditingController();

  final isCheck = false.obs;

  Rx<Country> selectedDialogCountry = CountryPickerUtils.getCountryByPhoneCode('91').obs;
  Rx<Country> selectedCountry = CountryPickerUtils.getCountryByPhoneCode('91').obs;
  RxString country = ''.obs;
  RxString countryCode = ''.obs;
  RxString isoCode = ''.obs;
  RxString state = ''.obs;
  RxString city = ''.obs;

  String countryId = '';
  String stateId = '';
  String cityId = '';

  RxBool isPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;
  late SharedPreferences sharedPreferences;
  late int isVerificationMode;
  String languageCode = "en";

  RxList<GradesData> grades = <GradesData>[].obs;

  RxList<CountryData> countryList = <CountryData>[].obs;

  RxList<StateData> stateList = <StateData>[].obs;

  RxList<StateData> cityList = <StateData>[].obs;


  int index1 = 0;

  //RxList<GradesData> selectedGrades = <GradesData>[].obs;

  //RxList<SubjectData> selectedSubjects = <SubjectData>[].obs;

  RxList<GradeSubjectModelUpdate> gradesSubjectsList = <GradeSubjectModelUpdate>[].obs;

  RxString outletsSelectedName = "".obs;

  var textfieldControllers = <TextEditingController>[].obs;

  RxBool isExpand = false.obs;

  TextEditingController searchContoller = TextEditingController();

 // var subjects = <SubjectDataNew>[].obs;
  var commitionRate = "".obs;


  @override
  Future<void> onInit() async {
    super.onInit();
     sharedPreferences = await SharedPreferences.getInstance();
    addTextField();
    callGradeListService();
    callCountryListService();
    callExtraDetailsService();
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
    gradesSubjectsList.add(GradeSubjectModelUpdate(selectedGrades:RxList.empty(), selectedSubjects: RxList.empty(),tempSelectedSubjects: RxList.empty(),subjects: RxList.empty()));
  }

  void signUpService() {
    CommonUtils.getIntance().hidekeyboard(Get.context!);
    if(teacherNameController.text.trim().isEmpty){
      CommonUtils.getIntance().toastMessage(AppText.please_enter_teacher_name);
    }else if (emailController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_email);
    }else if (!isValidEmail(emailController.text.trim())) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_valid_email);
    } else if (mobileController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_mobile_number);
    }else if (mobileController.text.trim().length < 7 || mobileController.text.trim().length > 15) {
      CommonUtils.getIntance().toastMessage(AppText.mobile_number_validation);
    } else if(isGradeValidate() == false){
      CommonUtils.getIntance().toastMessage(AppText.please_select_grades);
    } else if(isSubjectValidate() == false){
      CommonUtils.getIntance().toastMessage(AppText.please_select_subjects);
    }else if (country.isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_select_country);
    }/*else if (state.isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_select_state);
    }else if (city.isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_select_city);
    }*/else if (experienceController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_experience);
    } else if (educationBackgroundController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_education_background);
    }else if (interestController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_interest);
    }else if (spokenLangaugesController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_spoken_language);
    }else if (descriptionController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_description);
    }else if (ratePerHoursController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_rate);
    }else if (passwordController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_password);
    }else if (!isValidPassword(passwordController.text.trim())) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_valid_password);
    }else if (passwordController.text.trim().length < 8) {
      CommonUtils.getIntance().toastMessage(AppText.password_must_be_8_characters);
    }else if (passwordController.text.trim().length > 15) {
      CommonUtils.getIntance().toastMessage(AppText.password_may_not_greater_than_15_characters);
    }else if (confirmPasswordController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_confirm_password);
    }else if (confirmPasswordController.text.trim().toString() != passwordController.text.trim().toString()) {
      CommonUtils.getIntance().toastMessage(AppText.password_confirm_password_not_matched);
    }else{
      nextScreen();
    }
  }

  Future<void> nextScreen() async {

    List<String> gradesArray = [];
    List<String> subjectArray = [];

    for(int i=0; i<gradesSubjectsList.length; i++){
      gradesArray.add(gradesSubjectsList[i].selectedGrades[0].id.toString());

      for(int j=0;j<gradesSubjectsList[i].selectedSubjects.length ; j++){
        subjectArray.add(gradesSubjectsList[i].selectedSubjects[j].id.toString());
      }
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['full_name'] = teacherNameController.value.text.trim();
      data['email'] = emailController.value.text.trim();
      data['country_code'] = emailController.value.text.trim();
      data['mobile_number'] = mobileController.value.text.trim();
      data['country_code'] = countryCode.value.toString();
      data['iso_code'] = isoCode.value.toString();
      data['grade'] = gradesArray.join(',');
      data['subjects'] = subjectArray.join(',');
      data['country'] = countryId;
      if(state.value.isNotEmpty) {
        data['state'] = stateId;
      }
      if(city.value.isNotEmpty){
        data['city'] = cityId;
      }
      data['experience'] = experienceController.value.text.trim();
      data['education'] = educationBackgroundController.value.text.trim();
      data['interests'] = interestController.value.text.trim();
      data['known_languages'] = spokenLangaugesController.value.text.trim();
      data['description'] = descriptionController.value.text.trim();
      data['rate_per_hour'] = ratePerHoursController.value.text.trim();
      data['password'] = passwordController.value.text.trim();
      return data;
    }

    print("RAJNIKANT"+toJson().toString());

   // Get.toNamed(Routes.SIGN_UP_2,arguments:toJson());
    callCheckEmailExistService(toJson());
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

  // call grade_list service
  Future<void> callGradeListService() async {

    var apiService = _repository.sendGetApiNoParamRequest(grade_list);

    callDataService(
        apiService,
        onSuccess: successResponseGradeList,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseGradeList(dynamic baseResponse) async {
    GradesModel response = GradesModel.fromJson(baseResponse.data);
    if(response.success == true){
      grades.addAll(response.data!);
    }
  }


  Future<void> callExtraDetailsService() async {

    var apiService = _repository.sendGetApiNoParamRequest(extra_details);

    callDataService(
        apiService,
        onSuccess: successResponseExtraDetails,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseExtraDetails(dynamic baseResponse) async {
    SignupModel response = SignupModel.fromJson(baseResponse.data);
    if(response.success == true){
      commitionRate.value = response.commission_rate.toString();
    }
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


  // call grade_list service
  Future<void> callStateListService(String countryId) async {

    stateList.clear();
    cityList.clear();
    stateId = '';
    cityId = '';
    state.value = '';
    city.value = '';

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['country_id'] = countryId;
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,state_list,false);

    callDataService(
        apiService,
        onSuccess: successResponseStateList,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseStateList(dynamic baseResponse) async {
    StateModel response = StateModel.fromJson(baseResponse.data);
    if(response.success == true){
      stateList.addAll(response.data!);
    }
  }

  // call grade_list service
  Future<void> callCityListService(String stateId) async {

    cityList.clear();
    cityId = '';
    city.value = '';

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['state_id'] = stateId;
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,city_list,false);

    callDataService(
        apiService,
        onSuccess: successResponseCityList,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseCityList(dynamic baseResponse) async {
    StateModel response = StateModel.fromJson(baseResponse.data);
    if(response.success == true){
      cityList.addAll(response.data!);
    }else{
      CommonUtils.getIntance().toastMessage(response.responseMsg.toString());
    }
  }


  // call grade_list service
  Future<void>  callSubjectListService(String grades,int index) async {
    gradesSubjectsList[index].subjects.clear();
    gradesSubjectsList[index].duplicateSubjects.clear();
    index1 = index;
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['grade_id[]'] = grades;
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,subject_list,false);

    callDataService(
        apiService,
        onSuccess: successResponseSubjectList,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseSubjectList(dynamic baseResponse) async {
    SubjectModelNew response = SubjectModelNew.fromJson(baseResponse.data);
    if(response.success == true){

     // subjects.assignAll(response.data!);
      gradesSubjectsList[index1].subjects.clear();
      gradesSubjectsList[index1].tempSubjects.clear();
      gradesSubjectsList[index1].duplicateSubjects.clear();
      gradesSubjectsList[index1].selectedSubjects.clear();
      gradesSubjectsList[index1].tempSelectedSubjects.clear();

      if(response.data!.isNotEmpty){
        gradesSubjectsList[index1].subjects.assignAll(response.data!);
        gradesSubjectsList[index1].duplicateSubjects.assignAll(response.data!);
        gradesSubjectsList[index1].tempSubjects.assignAll(response.data!);
      }

    }
  }


  bool isValidEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  bool isValidPassword(String password) {
    // Regular expression to check the password
    String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*\W).+$';
    //String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  bool isGradeValidate() {
    bool isValid = true;

    for (var i=0; i<gradesSubjectsList.length;i++) {
      if (gradesSubjectsList[i].selectedGrades.isEmpty) {
        isValid = false;
      }
    }

    return isValid;
  }

  bool isSubjectValidate() {
    bool isValid = true;

    for (var i=0; i<gradesSubjectsList.length;i++) {
      if (gradesSubjectsList[i].selectedSubjects.isEmpty) {
        isValid = false;
      }
    }

    return isValid;
  }

  void filterSearchResults(String query, int index) {
    List<SubjectDataNew> filteredSubjects = [];

    for (var subject in gradesSubjectsList[index].duplicateSubjects.value) {
      var filteredSubject = filterSubject(subject, query);
      if (filteredSubject != null) {
        filteredSubjects.add(filteredSubject);
      }
    }

    gradesSubjectsList[index].subjects.value = filteredSubjects;
  }

  SubjectDataNew? filterSubject(SubjectDataNew subject, String query) {
    if (subject.subject!.toLowerCase().contains(query.toLowerCase())) {
      return subject;
    }

    List<SubjectDataNew> filteredChildren = [];
    for (var child in subject.children!) {
      var filteredChild = filterSubject(child, query);
      if (filteredChild != null) {
        filteredChildren.add(filteredChild);
      }
    }

    if (filteredChildren.isNotEmpty) {
      return SubjectDataNew(
        id: subject.id,
        subject: subject.subject,
        parentId: subject.parentId,
        isSelect: subject.isSelect,
        children: filteredChildren,
      );
    }

    return null;
  }

  void callCheckEmailExistService(Map<String, dynamic> json){
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['country_code'] = countryCode.value.toString();
      data['email'] = emailController.value.text.trim();
      data['mobile_number'] = mobileController.value.text.trim();

      return data;
    }

    var service = _repository.sendPostApiRequest(toJson,check_mobile_email_exists,false);

    callDataService(
      service,
      onSuccess: (baseResponse) => successResponseCheckEmailExist(baseResponse, json),
      onError: handleOnErrorEmailExist,
      isShowLoading: true,
    );
  }

  Future<void> successResponseCheckEmailExist(dynamic response,Map<String, dynamic> json) async {

    BaseModel baseResponse = BaseModel.fromJson(response.data);
    if(baseResponse.success == true){
      Get.toNamed(Routes.SIGN_UP_2,arguments:json);
    }else{
      Fluttertoast.showToast(
          msg: baseResponse.response_msg.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Clr.primaryColor,
          textColor: Clr.white,
          fontSize: 16.0
      );
    }

  }

  // error response manage here
  void handleOnErrorEmailExist(dynamic e) {
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


}
