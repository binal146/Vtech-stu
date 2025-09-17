import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vteach_teacher/app/core/utils/common_widgets.dart';
import 'package:vteach_teacher/app/core/values/comman_text.dart';
import 'package:vteach_teacher/app/core/values/text_styles.dart';
import 'package:vteach_teacher/app/modules/agora_demo/model/AgoraModel.dart';
import 'package:vteach_teacher/app/modules/appointment_detail/model/AppointmentData.dart';
import 'package:vteach_teacher/app/modules/appointment_detail/model/AppointmentModel.dart';
import '../../core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/not_found_exception.dart';
import '../../routes/app_pages.dart';
import '../agora_demo/agora_demo_controller.dart';
import '../request_appointment_detail/model/CancelReasonData.dart';
import '../request_appointment_detail/model/CancelReasonModel.dart';
import '/app/core/base/base_controller.dart';

class AppointmentDetailController extends BaseController {

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());
  final emailController = TextEditingController();

  RxString appointmentType = "".obs;

  RxInt selectedValue = 0.obs;
  late var bookingData = Rxn<AppointmentData>();

  RxList<CancelReasonData> reasonList = <CancelReasonData>[].obs;
  final reasonController = TextEditingController();

  String bookingId = "";
  String bookingSlotId = "";
  String open_call_history = "";
  RxBool isChatShow = false.obs;


  @override
  Future<void> onInit() async {
    super.onInit();
    appointmentType.value = Get.parameters['type']!;
    bookingId = Get.parameters['bookingId']!;
    bookingSlotId = Get.parameters['bookingSlotId']!;
    open_call_history = Get.parameters['open_call_history']!;
    if(open_call_history == "1"){
      Future.delayed(Duration(milliseconds: 500),() {
        Get.toNamed(Routes.CALL_DETAIL,arguments: bookingSlotId);
      },);

    }
    callGetCancelReasonListService();
    callGetBookingDetailService();
  }

  Future<void> callSendNotificationService() async {

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['booking_id'] = bookingId;
      data['booking_slot_id'] = bookingSlotId;
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,send_vcall_notification,false);

    callDataService(
      apiService,
      onSuccess: successResponse,
      onError: handleOnError,
      isShowLoading: true,
    );
  }

  Future<void> successResponse(dynamic baseResponse) async {
    AgoraModel response = AgoraModel.fromJson(baseResponse.data);
    String agoraToken = response.data!.agoratoken ?? '';
    String channelName = response.data!.channel_id ?? '';
    String teacherUid = response.data!.teacherUid.toString() ?? '';
    String app_unique_call_id = response.data!.app_unique_call_id.toString() ?? '';
    String app_id = response.data!.agoraAppId ?? '';
    if(response.success == true){

      if(Get.isRegistered<AgoraDemoController>()){
        print("AgoraDemoController already registered");
      }

      Get.toNamed(Routes.AGORA_DEMO,
          arguments: bookingData.value,
          parameters: {
        'agora_token' : agoraToken,
        'channel_name' : channelName,
        'app_id' : app_id,
        'uid' : teacherUid,
        'app_unique_call_id' : app_unique_call_id,
        'booking_id' : bookingData.value!.bookingId.toString(),
        'booking_slot_id' : bookingData.value!.bookingSlotId.toString(),
        'student_name' : bookingData.value!.studentName.toString(),
        'student_id' : bookingData.value!.student_id.toString(),
        'profile_image' : bookingData.value!.studentProfile.toString(),
            'from_list' : "0"
      });

    }
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    // Check the statuses
    if (statuses[Permission.camera]!.isGranted && statuses[Permission.microphone]!.isGranted) {
      print("Permissions granted");
      callSendNotificationService();
    } else {
      print("Permissions not granted");
    }
  }

  void handleOnError(dynamic e) {
    if(e is NotFoundException){
      CommonUtils.getIntance().toastMessage(e.response_msg);
    }
  }

  Future<void> checkPermissions() async {
    bool cameraGranted = await requestCameraPermission();
    bool microphoneGranted = await requestMicrophonePermission();

    if (cameraGranted && microphoneGranted) {
      callSendNotificationService();
    } else {
      openSettingScreen();
    }
  }

  Future<bool> requestCameraPermission() async {
    return await requestPermission(Permission.camera);
  }

  Future<bool> requestMicrophonePermission() async {
    return await requestPermission(Permission.microphone);
  }

  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      // Permission already granted
      return true;
    } else {
      // Request permission
      final result = await permission.request();

      if (result.isGranted) {
        // Permission granted
        return true;
      } else {
        // Permission denied
        return false;
      }
    }
  }

  void openSettingScreen() {
    showDialog<String>(
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppText.permission, style: blackPoppinsSemiBold20),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(AppText.need_to_give_permission, style: blackPoppinsRegular18),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppText.open_setting),
            onPressed: () async {
              Get.back();
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  Future<void> callGetCancelReasonListService() async {

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['reason_type'] = "cancellation";
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,cancel_reason_list,false);

    callDataService(
      apiService,
      onSuccess: successResponseCancelReasonList,
      onError: handleOnErrorCancelReason,
      isShowLoading: true,
    );
  }

  Future<void> successResponseCancelReasonList(dynamic baseResponse) async {
    CancelReasonModel response = CancelReasonModel.fromJson(baseResponse.data);
    if(response.success == true){
      reasonList.value = response.data!;
      reasonList.value.add(CancelReasonData(reason: 'Other'));
    }
  }

  void handleOnErrorCancelReason(dynamic e) {
    if(e is NotFoundException){
      reasonList.value.add(CancelReasonData(reason: 'Other'));
    }
  }

  Future<void> callCancelAppointmentService(String reason) async {

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['booking_id'] = bookingData.value!.bookingId.toString();
      data['booking_slot_id'] = bookingData.value!.bookingSlotId.toString();
      data['reject_reason'] = reason;
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,cancel_booking,false);

    callDataService(
      apiService,
      onSuccess: successResponseAcceptReject,
      onError: handleOnError,
      isShowLoading: true,
    );
  }

  Future<void> successResponseAcceptReject(dynamic baseResponse) async {
    BaseModel response = BaseModel.fromJson(baseResponse.data);
    if(response.success == true) {
      CommonUtils.getIntance().toastMessage(response.response_msg!);
      Get.back(result: true);
    }
  }

  void handleOnErrorBookingDetail(dynamic e) {
    if(e is NotFoundException){
      CommonUtils.getIntance().toastMessage(e.response_msg);
    }
  }

  Future<void> callGetBookingDetailService() async {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['booking_id'] = bookingId;
      data['booking_slot_id'] = bookingSlotId;
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,get_booking_details,false);

    callDataService(
      apiService,
      onSuccess: successResponseGetBookingDetail,
      onError: handleOnErrorBookingDetail,
      isShowLoading: true,
    );
  }

  Future<void> successResponseGetBookingDetail(dynamic baseResponse) async {
    AppointmentModel response = AppointmentModel.fromJson(baseResponse.data);
    if(response.success == true){
      bookingData.value = response.data!;
      if(bookingData.value?.bookingStatus == "completed") {
        isCompleted5Minutes(bookingData.value!.date.toString(),bookingData.value!.time.toString());
      }
  // added by rajnikant
      if( bookingData.value?.bookingStatus == "completed" ||
          bookingData.value?.bookingStatus == "cancel" ||
          bookingData.value?.bookingStatus == "rejected") {
        if(appointmentType.value == "0") {
          appointmentType.value = "1";
        }
      }
    }

  }

  void isCompleted5Minutes(String sessionDate,String sessionTime) {
    String date = sessionDate;
    String time = sessionTime;
    String endTime = getLastTime(time);

    // Parse the date and time
    DateTime parsedDateTime = parseDateTime(date, endTime);

    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the time after 5 minutes from the specified time
    DateTime triggerTime = parsedDateTime.add(Duration(minutes: 5));

    // Calculate the difference
    Duration delay = triggerTime.difference(now);

    // If the time has already passed, execute immediately
    if (delay.isNegative) {
      isChatShow.value = false;
    } else {
      isChatShow.value = true;
      Timer(delay, () {
        isChatShow.value = false;
      });
    }
  }

  String getLastTime(String time) {
    List<String> timeParts = time.split('-');

    return timeParts.last.trim();
  }

  DateTime parseDateTime(String date, String time) {
    String formattedTime = convertTo24HourFormat(time);
    String formattedDateTime = "$date $formattedTime";
    return DateTime.parse(formattedDateTime);
  }

  String convertTo24HourFormat(String time) {
    final timeParts = time.split(" ");
    final period = timeParts[1].toUpperCase(); // AM or PM
    final timeWithoutPeriod = timeParts[0];
    final hoursMinutes = timeWithoutPeriod.split(":");
    int hours = int.parse(hoursMinutes[0]);
    final minutes = hoursMinutes[1];

    if (period == "PM" && hours != 12) {
      hours += 12;
    } else if (period == "AM" && hours == 12) {
      hours = 0;
    }
    return "${hours.toString().padLeft(2, '0')}:$minutes:00";
  }
}
