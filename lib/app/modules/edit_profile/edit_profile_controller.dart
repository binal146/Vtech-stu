import 'dart:convert';

import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/GradesData.dart';
import '../../core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/sharePrefrenceConst.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../GradeSubjectModelUpdated.dart';
import '../my_profile/model/MyProfileData.dart';
import '../signup_1/model/CountryData.dart';
import '../signup_1/model/CountryModel.dart';
import '../signup_1/model/GradesModel.dart';
import '../signup_1/model/SignUpModel.dart';
import '../signup_1/model/StateData.dart';
import '../signup_1/model/StateModel.dart';
import '../signup_1/model/SubjectData.dart';
import '/app/core/base/base_controller.dart';
import 'package:dio/dio.dart' as MULTI;
import 'model/GradeSubjectModelNew.dart';
import 'model/SubjectDataUpdate.dart';
import 'model/SubjectModelUpdate.dart';

class EditProfileController extends BaseController {

  final ProjectRepository _repository =
  Get.find(tag: (ProjectRepository).toString());

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final experienceController = TextEditingController();
  final educationBackgroundController = TextEditingController();
  final interestController = TextEditingController();
  final spokenLanguageController = TextEditingController();
  final descriptionController = TextEditingController();
  final ratePerHoursController = TextEditingController();

  Rx<Country> selectedDialogCountry = CountryPickerUtils.getCountryByPhoneCode('').obs;

  late SharedPreferences sharedPreferences;

  RxList<GradesData> selectedGrades = <GradesData>[].obs;
  RxList<GradesData> grades = <GradesData>[].obs;

  late var myProfileData = Rxn<MyProfileData>();

  String interests = "";
  String knownLangauges = "";

  List<String> interestList = [];
  List<String> knowLanguagesList = [];

  RxString outletsSelectedName = "".obs;

 // RxList<SubjectData> subjects = <SubjectData>[].obs;
  RxList<SubjectData> selectedSubjects = <SubjectData>[].obs;

  RxList<CountryData> countryList = <CountryData>[].obs;

  RxString country = ''.obs;
  RxString state = ''.obs;
  RxString city = ''.obs;

  String countryId = '';
  String stateId = '';
  String cityId = '';

  RxList<StateData> stateList = <StateData>[].obs;

  RxList<StateData> cityList = <StateData>[].obs;

  var selectedImage = Rx<XFile?>(null);
  final ImagePicker picker = ImagePicker();

  var images = <XFile?>[].obs;

  var textfieldControllers = <TextEditingController>[].obs;
 // RxList<GradeSubjectModel> gradesSubjectsList = <GradeSubjectModel>[].obs;
  RxList<GradeSubjectModelUpdated> gradesSubjectsList = <GradeSubjectModelUpdated>[].obs;
  int index1 = 0;
  String userId = "";

  TextEditingController searchContoller = TextEditingController();

  bool isDataUpdated = false;
  RxString countryCode = ''.obs;
  RxString isoCode = ''.obs;
  var commitionRate = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    myProfileData = Get.arguments;
    sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getInt(SharePreferenceConst.user_id).toString();
    for(var interest in myProfileData.value!.interests!){
      interestList.add(interest.interest.toString());
    }

    for(var knowLanguages in myProfileData.value!.knownLanguages!){
      knowLanguagesList.add(knowLanguages.known_language.toString());
    }

    interests = interestList.join(',');
    knownLangauges = knowLanguagesList.join(',');
    callExtraDetailsService();
    callCountryListService();
    callStateListService(myProfileData.value!.country_id.toString());
    callCityListService(myProfileData.value!.state_id.toString());
    callGradeListService();
    callGradeSubjectListService();
    setProfileData();
  }

  bool isValidEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  void addTextField() {
    textfieldControllers.add(TextEditingController());
    gradesSubjectsList.add(GradeSubjectModelUpdated(selectedGrades:RxList.empty(), selectedSubjects: RxList.empty(),subjects: RxList.empty()));
  }

  void setProfileData() {
    countryCode.value = myProfileData.value!.countryCode.toString();
    fullNameController.text = myProfileData.value!.fullName.toString();
    emailController.text = myProfileData.value!.email.toString();
    mobileController.text = myProfileData.value!.mobileNumber.toString();
    experienceController.text = myProfileData.value!.experience.toString();
    educationBackgroundController.text = myProfileData.value!.education.toString();
    ratePerHoursController.text = myProfileData.value!.rate.toString();
    interestController.text = interests;
    spokenLanguageController.text = knownLangauges;
    descriptionController.text = myProfileData.value!.description.toString();
    selectedGrades.value.addAll(myProfileData.value!.grade!);
    selectedSubjects.value.addAll(myProfileData.value!.subject!);
    countryId = myProfileData.value!.country_id!;
    stateId = myProfileData.value!.state_id!;
    cityId = myProfileData.value!.city_id!;
    callSubjectListApi();
  }

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

      for(var country1 in countryList){
        if(country1.id.toString() == myProfileData.value!.country_id){
          country.value = country1.name.toString();
        }
      }

    }
  }

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
      for(var state1 in stateList){
        if(state1.id.toString() == myProfileData.value!.state_id){
          state.value = state1.name.toString();
        }
      }
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
      for(var city1 in cityList){
        if(city1.id.toString() == myProfileData.value!.city_id){
          city.value = city1.name.toString();
        }
      }
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

  void callSubjectListApi() {

    List<String> filteredList = [];
    for(int i = 0; i<selectedGrades.length; i++){
      filteredList.add(selectedGrades[i].id.toString());
    }

    String grades = filteredList.join(',');
    //callSubjectListService(grades,index);
  }

  void updateProfile() {
    if(fullNameController.text.trim().isEmpty){
      CommonUtils.getIntance().toastMessage(AppText.please_enter_teacher_name);
    }else if(isGradeValidate() == false){
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
    }else if (spokenLanguageController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_spoken_language);
    }else if (ratePerHoursController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_rate);
    }else if (descriptionController.text.trim().isEmpty) {
      CommonUtils.getIntance().toastMessage(AppText.please_enter_description);
    }else{
      callUpdateProfileService();
    }
  }

  Future<void> callUpdateProfileService() async {
    List<String> gradesArray = [];
    List<String> subjectArray = [];

/*    for(int i=0;i<selectedGrades.length;i++){
      gradesArray.add(selectedGrades[i].id.toString());
    }

    for(int i=0;i<selectedSubjects.length;i++){
      subjectArray.add(selectedSubjects[i].id.toString());
    }*/

    for(int i=0; i<gradesSubjectsList.length; i++){
      gradesArray.add(gradesSubjectsList[i].selectedGrades[0].id.toString());

      for(int j=0;j<gradesSubjectsList[i].selectedSubjects.length ; j++){
        subjectArray.add(gradesSubjectsList[i].selectedSubjects[j].id.toString());
      }
    }

    Map<String, dynamic> toJson()  {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['full_name'] = fullNameController.value.text.trim();
      data['grade'] = gradesArray.join(',');
      data['subjects'] = subjectArray.join(',');
      data['country'] = countryId;
      if(state.value.isNotEmpty) {
        data['state'] = stateId;
      }
      if(city.value.isNotEmpty) {
        data['city'] = cityId;
      }
      data['experience'] = experienceController.value.text.trim();
      data['education'] = educationBackgroundController.value.text.trim();
      data['interests'] = interestController.value.text.trim();
      data['known_languages'] = spokenLanguageController.value.text.trim();
      data['rate_per_hour'] = ratePerHoursController.value.text.trim();
      data['description'] = descriptionController.value.text.trim();
      if(selectedImage.value != null) {
       // MultipartFile file= await MultipartFile.fromFile(image!.path, filename: image.name)
        MULTI.MultipartFile file = MULTI.MultipartFile.fromFileSync(selectedImage.value!.path, filename: selectedImage.value!.name);
        data['profile_image'] = file;

      }

      return data;
    }

    print("My json response is --->"+toJson().toString());

    var apiService = _repository.sendMultipartApiRequest(toJson(),update_profile,false);

    callDataService(
        apiService,
        onSuccess: successResponseUpdateProfile,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseUpdateProfile(dynamic baseResponse) async {

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
      Get.back(result: true);
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = XFile(pickedFile.path);
    }
  }

  // call grade_list service
  Future<void>  callSubjectListService(String grades,int index) async {
    gradesSubjectsList[index].subjects.clear();
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
    SubjectModelUpdate response = SubjectModelUpdate.fromJson(baseResponse.data);
    if(response.success == true){

/*      gradesSubjectsList[index1].subjects.clear();
      gradesSubjectsList[index1].selectedSubjects.clear();
      gradesSubjectsList[index1].tempSelectedSubjects.clear();*/

      gradesSubjectsList[index1].subjects.clear();
      gradesSubjectsList[index1].tempSubjects.clear();
      gradesSubjectsList[index1].duplicateSubjects.clear();
      gradesSubjectsList[index1].selectedSubjects.clear();
      gradesSubjectsList[index1].tempSelectedSubjects.clear();

      if(response.data!.isNotEmpty){
       // gradesSubjectsList[index1].subjects.addAll(response.data!);
        gradesSubjectsList[index1].subjects.assignAll(response.data!);
        gradesSubjectsList[index1].duplicateSubjects.assignAll(response.data!);
        gradesSubjectsList[index1].tempSubjects.assignAll(response.data!);
      }
    }
  }

  Future<void> callGradeSubjectListService() async {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      return data;
    }
    var apiService = _repository.sendPostApiRequest(toJson,grade_subject_list,false);
    callDataService(
        apiService,
        onSuccess: successResponseGradeSubjectList,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseGradeSubjectList(dynamic baseResponse) async {
    GradeSubjectModelNew response = GradeSubjectModelNew.fromJson(baseResponse.data);
    if(response.success == true){
      if(response.data!.isNotEmpty){
        for(int i=0; i<response.data!.length; i++){
          addTextField();
          for(int j=0; j<grades.length; j++){
            if(response.data![i].id == grades[j].id){
              gradesSubjectsList[i].selectedGrades.add(grades[j]);
            }
          }

          gradesSubjectsList[i].subjects.addAll(response.data![i].subjects!);
          gradesSubjectsList[i].jsonValue = jsonEncode(response.data![i].subjects!);
          gradesSubjectsList[i].duplicateSubjects.addAll(response.data![i].subjects!);
          gradesSubjectsList[i].tempSubjects.addAll(response.data![i].subjects!);
          getSelectedSubjectList(response.data![i].subjects!,i);
          gradesSubjectsList[i].tempSelectedJson = jsonEncode(gradesSubjectsList[i].tempSelectedSubjects);
        }
      }
    }
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
    List<SubjectDataUpdate> filteredSubjects = [];

    for (var subject in gradesSubjectsList[index].duplicateSubjects.value) {
      var filteredSubject = filterSubject(subject, query);
      if (filteredSubject != null) {
        filteredSubjects.add(filteredSubject);
      }
    }

    gradesSubjectsList[index].subjects.value = filteredSubjects;
  }

  SubjectDataUpdate? filterSubject(SubjectDataUpdate subject, String query) {
    if (subject.subject!.toLowerCase().contains(query.toLowerCase())) {
      return subject;
    }

    List<SubjectDataUpdate> filteredChildren = [];
    for (var child in subject.children!) {
      var filteredChild = filterSubject(child, query);
      if (filteredChild != null) {
        filteredChildren.add(filteredChild);
      }
    }

    if (filteredChildren.isNotEmpty) {
      return SubjectDataUpdate(
        id: subject.id,
        subject: subject.subject,
        parentId: subject.parentId,
        isSelect: subject.isSelect,
        isPartiallySelected: subject.isPartiallySelected,
        children: filteredChildren,
      );
    }

    return null;
  }

  void getSelectedSubjectList(List<SubjectDataUpdate> subjects,int mainIndex) {
    for (var subject in subjects) {
      if(subject.isSelect.value){
        gradesSubjectsList[mainIndex].selectedSubjects.add(subject);
        gradesSubjectsList[mainIndex].tempSelectedSubjects.add(subject);
      }
      if (subject.children.isNotEmpty) {
        getSelectedSubjectList(subject.children,mainIndex);
      }
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
}
