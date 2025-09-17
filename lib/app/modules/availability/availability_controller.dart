import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/core/base/BaseModel.dart';
import 'package:vteach_teacher/app/core/utils/common_widgets.dart';
import 'package:vteach_teacher/app/modules/TimeslotModel.dart';
import 'package:vteach_teacher/app/modules/availability/model/AvailableSlotsModel.dart';
import 'package:vteach_teacher/app/modules/availability/model/SlotDate.dart';
import 'package:vteach_teacher/app/modules/availability/model/TimeslotDateModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/sharePrefrenceConst.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../../network/exceptions/not_found_exception.dart';
import '/app/core/base/base_controller.dart';

class AvailablityController extends BaseController {

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());

  RxList<Timeslotmodel> timeslotsList = <Timeslotmodel>[].obs;

  RxList<Timeslotmodel> timeslotsListTemp = <Timeslotmodel>[].obs;

  String screen = "";
  //TimeOfDay selectedTime = TimeOfDay.now();
  RxString startTime = "".obs;
  RxString endTime = "".obs;

  List<dynamic> convertedList = [];
  Map<String,dynamic> myJson = <String,dynamic>{};

  RxString selectedDate = ''.obs;
  RxString dateCount = ''.obs;
  RxString range = ''.obs;
  RxString rangeCount = ''.obs;

  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  RxString singleDate = ''.obs;

  RxString start_time = "9".obs;
  RxString end_time = "18".obs;

  RxString start_time_am = "AM".obs;
  RxString end_time_pm = "PM".obs;
  String userId = "";
  RxString timezoneText = "".obs;
  String startTimeEdit = "";
  String endTimeEdit = "";
  RxBool isRangeSelected = true.obs;

  RxString outletsSelectedName = "".obs;

  RxString? initialSelectedDate = ''.obs;
  RxList<DateTime> availableDateList = <DateTime>[].obs;


  RxList<SlotDate> slotDatesList = <SlotDate>[].obs;
  var selectedHour = 0.obs;
  RxBool isAmSelected = true.obs;
  RxBool isDataLoaded = false.obs;
  RxString emptyMessage = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    screen = Get.arguments;
    isDataLoaded.value = false;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getInt(SharePreferenceConst.user_id).toString();
    timezoneText.value = sharedPreferences.getString(SharePreferenceConst.timezone_text).toString();

    if(screen == "0"){
      generateTimeslots(9,18);
    }else{
      callGetSlotDatesService();
    }

  }

  void generateTimeslots(int start,int end) {
    timeslotsList.clear();
    timeslotsListTemp.clear();
    DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, start, 0);
    DateTime endTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, end, 0);
    List<String> timeslots = [];

    DateFormat timeFormat = DateFormat.jm(); // Format the time as AM/PM
    DateFormat timeFormat2 = DateFormat.Hms();

    while (startTime.isBefore(endTime)) {
      final endTimeSlot = startTime.add(Duration(hours: 1));
      timeslots.add('${timeFormat.format(startTime)} - ${timeFormat.format(endTimeSlot)}');
      timeslotsList.add(Timeslotmodel(time: '${timeFormat.format(startTime)} - ${timeFormat.format(endTimeSlot)}',isSelect: false.obs));
      timeslotsListTemp.add(Timeslotmodel(time: '${timeFormat2.format(startTime)} - ${timeFormat2.format(endTimeSlot)}',isSelect: false.obs));
      startTime = endTimeSlot;
    }
  }


  void callService() {
    convertedList.clear();
    List<String> timeslotsArray = [];
    for(var timeslot in timeslotsListTemp){
      if(timeslot.isSelect!.value){
        timeslotsArray.add(timeslot.time.toString());
      }
    }

    for(int i=0; i<timeslotsArray.length;i++){
      List<String> times = timeslotsArray[i].split(' - ');
      String startTime = times[0].trim();
      String endTime = times[1].trim();
      addTimeSlot(startTime,endTime);
    }

    Map<String, dynamic> toJson() {
      return myJson;
    }
    print("Final request values ---> "+toJson().toString());


    if(screen == "0") {
      if (startDate.isEmpty || endDate.isEmpty) {
        CommonUtils.getIntance().toastMessage(AppText.please_select_startdate_and_enddate);
      } else if (convertedList.isEmpty) {
        CommonUtils.getIntance().toastMessage(AppText.please_select_timeslots);
      }else {
        callSetAvailabiltyService(toJson);
      }
    } else{
      if (singleDate.isEmpty) {
        CommonUtils.getIntance().toastMessage(AppText.please_select_date);
      } else if (convertedList.isEmpty) {
        CommonUtils.getIntance().toastMessage(AppText.please_select_timeslots);
      } else {
        callUpdateAvailabiltyService(toJson);
      }
    }

  }

  void addTimeSlot(String startTime, String endTime) {
    Map<String, dynamic> timeslot = {
      'start_time': startTime,
      'end_time': endTime,
    };

    convertedList.add(timeslot);
    if(screen == "0"){
      myJson['start_date'] = startDate.value;
      myJson['end_date'] = endDate.value;
    }else{
      myJson['date'] = singleDate.value;
    }
    myJson['timeslots'] = convertedList;

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

  Future<void> callSetAvailabiltyService(Map<String, dynamic> Function() toJson) async {

   // toJson()['rate_per_hour'] = ratesController.value.text.trim().toString();

    Map<String, dynamic> toJsonData() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['availability'] = jsonEncode(toJson());
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJsonData,set_availability,false);

    callDataService(
        apiService,
        onSuccess: successResponseSetAvailability,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseSetAvailability(dynamic baseResponse) async {
    BaseModel response = BaseModel.fromJson(baseResponse.data);
    CommonUtils.getIntance().toastMessage(response.response_msg.toString());
    if(response.success == true){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool(SharePreferenceConst.isLogin, true);
      Get.back(result: true);
    }

  }

  String convert24HourTo12Hour(String time24,bool isStart) {
    // Parse the input time in 24-hour format
    DateTime dateTime = DateFormat('HH').parse(time24);

    // Format the DateTime object to 12-hour format
    String time12 = DateFormat('hh:mm a').format(dateTime);

    print("Rajnikant--->"+time12);

    if(isStart){
      if(time12.contains('AM')){
        start_time_am.value = "AM";
      }else{
        start_time_am.value = "PM";
      }
    }else{
      if(time12.contains('AM')){
        end_time_pm.value = "AM";
      }else{
        end_time_pm.value = "PM";
      }
    }

    return time12;
  }

  Future<void> callGetSlotDatesService() async {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,get_slot_date,false);

    callDataService(
        apiService,
        onSuccess: successResponseGetSlotDates,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseGetSlotDates(dynamic baseResponse) async {

    TimeslotDateModel response = TimeslotDateModel.fromJson(baseResponse.data);
    if(response.success == true){
      slotDatesList.addAll(response.data!.slotDate!);
      singleDate.value = convertDateFormat(slotDatesList[0].date.toString());
      callGetSlotsService(slotDatesList[0].date.toString());
      initialSelectedDate!.value = slotDatesList[0].date.toString();
      for(var date in slotDatesList){
        availableDateList.add(DateTime.parse(date.date.toString()));
      }

    }


  }


  Future<void> callGetSlotsService(String date) async {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['date'] = date;
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,get_slot,false);

    callDataService(
        apiService,
        onSuccess: successResponseGetSlots,
        onError: handleOnErrorSlot,
        isShowLoading: true
    );
  }

  Future<void> successResponseGetSlots(dynamic baseResponse) async {
    isDataLoaded.value = true;

    AvailableSlotsModel response = AvailableSlotsModel.fromJson(baseResponse.data);

    if(response.success == true){
      timeslotsList.assignAll(response.data!.timeslots!);

      start_time.value = convertTo24HourFormat(getStartTimeAMPM(response.data!.timeslots![0].time.toString()).trim());
      end_time.value = convertTo24HourFormat(getEndTimeAMPM(response.data!.timeslots![response.data!.timeslots!.length - 1].time.toString()).trim());
      startTimeEdit = convertTo24HourFormat(getStartTimeAMPM(response.data!.timeslots![0].time.toString()).trim());
      endTimeEdit = convertTo24HourFormat(getEndTimeAMPM(response.data!.timeslots![response.data!.timeslots!.length - 1].time.toString()).trim());
      generateTimeslotsEdit(int.parse(startTimeEdit),int.parse(endTimeEdit));
    }
  }

  void handleOnErrorSlot(dynamic e) {
  /*  if(e is ApiException){
      Fluttertoast.showToast(msg: e.response_msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Clr.primaryColor,
          textColor: Clr.white,
          fontSize: 16.0
      );
    }*/

    if(e is NotFoundException){
      timeslotsList.clear();
      emptyMessage.value = e.response_msg;
      print("SSSSSSSSSS"+start_time.value.toString());
      print("SSSSSSSSSS"+end_time.value.toString());
      generateTimeslots(int.parse(start_time.value), int.parse(end_time.value));
    }

  }

  String getStartTimeAMPM(String time) {
    List<String> parts = time.split('-');
    return parts[0];
  }

  String getEndTimeAMPM(String time) {
    List<String> parts = time.split('-');
    return parts[1];
  }

  String getStartTime(String time) {
    List<String> parts = time.split(' ');
    return parts[0];
  }

  String getEndTime(String time) {
    List<String> parts = time.split(' ');
    return parts[0];
  }

  String getAmPm(String time) {
    if(time.contains("AM")){
      return "AM";
    }else{
      return "PM";
    }
  }

  String convertTo24HourFormat(String time12Hour) {
    // Define the input format (12-hour)
    DateFormat inputFormat = DateFormat("hh:mm a");
    // Define the output format (24-hour)
    DateFormat outputFormat = DateFormat("HH");

    // Parse the input time string to a DateTime object
    DateTime dateTime = inputFormat.parse(time12Hour);

    // Format the DateTime object to a 24-hour format string
    String time24Hour = outputFormat.format(dateTime);

    return time24Hour;
  }

  void generateTimeslotsEdit(int start,int end) {
    timeslotsListTemp.clear();
    DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, start, 0);
    DateTime endTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, end, 0);
    List<String> timeslots = [];

    DateFormat timeFormat = DateFormat.jm(); // Format the time as AM/PM
    DateFormat timeFormat2 = DateFormat.Hms();
    int i = -1;
    while (startTime.isBefore(endTime)) {
      i++;
      final endTimeSlot = startTime.add(Duration(hours: 1));
      timeslots.add('${timeFormat.format(startTime)} - ${timeFormat.format(endTimeSlot)}');
      if(i < timeslotsList.length){
         timeslotsListTemp.add(Timeslotmodel(time: '${timeFormat2.format(startTime)} - ${timeFormat2.format(endTimeSlot)}',isSelect: timeslotsList[i].isSelect));
      }
      startTime = endTimeSlot;
    }
  }

  Future<void> callUpdateAvailabiltyService(Map<String, dynamic> Function() toJson) async {

   // toJson()['rate_per_hour'] = ratesController.value.text.trim().toString();

    Map<String, dynamic> toJsonData() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['availability'] = jsonEncode(toJson());
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJsonData,update_availability,false);

    callDataService(
        apiService,
        onSuccess: successResponseUpdateAvailability,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseUpdateAvailability(dynamic baseResponse) async {
    BaseModel response = BaseModel.fromJson(baseResponse.data);
    CommonUtils.getIntance().toastMessage(response.response_msg.toString());
    if(response.success == true){
      Get.back();
    }

  }

  String convertDateFormat(String dateInput) {
    DateTime dateTime = DateTime.parse(dateInput);
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return dateFormat.format(dateTime);
  }

}
