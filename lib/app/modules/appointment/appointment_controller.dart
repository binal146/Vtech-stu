import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/not_found_exception.dart';
import '../../routes/app_pages.dart';
import '../agora_demo/agora_demo_controller.dart';
import '../agora_demo/model/AgoraModel.dart';
import '../request_appointment_detail/model/CancelReasonData.dart';
import '/app/core/base/base_controller.dart';
import 'model/BookingData.dart';
import 'model/BookingModel.dart';

class AppoinmentController extends BaseController with GetSingleTickerProviderStateMixin {

  RxBool isUpcoming = true.obs;
  RxInt selectedFilter = 0.obs;
  RxBool isFilterApply = false.obs;

  RxString emptyMessage = "".obs;

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());
  RxList<BookingData> bookingList = <BookingData>[].obs;

  RxList<CancelReasonData> reasonList = <CancelReasonData>[].obs;

  BookingData bookingData = BookingData();

  var isLoading = false.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;
  final int pageSize = 25;


  @override
  Future<void> onInit() async {
    super.onInit();
    callGetBookingService('upcoming');
  }


  Future<void> callGetBookingService(String status,{int offset = 0}) async {

    if (offset == 0) {
      bookingList.clear();
    }
    if (!isLoading.value && hasMoreData.value) {
      isLoading.value = true;

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['status'] = status;
        data['offset'] = offset;
        if (selectedFilter.value != 0) {
          data['filter_status'] =
          (selectedFilter.value == 1) ? 'cancel' : (selectedFilter.value == 2)
              ? 'rejected'
              : 'completed';
        }
        return data;
      }

      var apiService = _repository.sendPostApiRequest(
          toJson, get_booking, false);

      callDataService(
        apiService,
        onSuccess: (baseResponse) => successResponseGetBooking(baseResponse, offset),
        onError: (errorResponse) => handleOnError(errorResponse, offset),
        isShowLoading: (offset == 0) ? true : false,
      );

      isLoading.value = false;
    }
  }

  Future<void> successResponseGetBooking(dynamic baseResponse,int offset) async {
    BookingModel response = BookingModel.fromJson(baseResponse.data);
    if(response.success == true){
      emptyMessage.value = "";
      if (response.data!.length < pageSize) {
        hasMoreData.value = false; // No more data to load
      }

      if (offset == 0) {
        bookingList.assignAll(response.data!); // First page load
      } else {
        bookingList.addAll(response.data!); // Append for pagination
      }
    }
  }

  void handleOnError(dynamic e,int offset) {
    if(e is NotFoundException){
      emptyMessage.value = e.response_msg;
      if(offset == 0) {
        bookingList.clear();
      }
      hasMoreData.value = false;
    }
  }


  Future<void> callSendNotificationService(BookingData bookingData1) async {
    bookingData = bookingData1;

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['booking_id'] = bookingData.booking_id;
      data['booking_slot_id'] = bookingData.booking_slot_id;
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,send_vcall_notification,false);

    callDataService(
      apiService,
      onSuccess: successResponse,
      onError: handleOnErrorNotification,
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
          arguments: bookingData,
          parameters: {
            'agora_token' : agoraToken,
            'channel_name' : channelName,
            'app_id' : app_id,
            'uid' : teacherUid,
            'app_unique_call_id' : app_unique_call_id,
            'booking_id' : bookingData.booking_id.toString(),
            'booking_slot_id' : bookingData.booking_slot_id.toString(),
            'student_name' : bookingData.studentName.toString(),
            'student_id' : bookingData.studentId.toString(),
            'profile_image' : bookingData.studentProfile.toString(),
            'from_list' : "1"
          });

     /* Get.toNamed(Routes.SCREEN_SHARE,
          arguments: bookingData,
          parameters: {
            'agora_token' : agoraToken,
            'channel_name' : channelName,
            'app_id' : app_id,
            'uid' : teacherUid,
            'app_unique_call_id' : app_unique_call_id,
            'booking_id' : bookingData.booking_id.toString(),
            'booking_slot_id' : bookingData.booking_slot_id.toString(),
            'student_name' : bookingData.studentName.toString(),
            'profile_image' : bookingData.studentProfile.toString(),
          });*/
    }
  }

  void handleOnErrorNotification(dynamic e) {
    if(e is NotFoundException){
      CommonUtils.getIntance().toastMessage(e.response_msg);
    }
  }

  Future<void> checkPermissions(BookingData bookingData) async {
    bool cameraGranted = await requestCameraPermission();
    bool microphoneGranted = await requestMicrophonePermission();

    if (cameraGranted && microphoneGranted) {
      callSendNotificationService(bookingData);
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
}


