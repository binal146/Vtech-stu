import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/modules/home/model/CheckAvailabilityModel.dart';
import 'package:vteach_teacher/app/modules/home/model/PendingBookingModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/values/sharePrefrenceConst.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../../network/exceptions/not_found_exception.dart';
import '../bottom__navigation_bar/BottomNavController.dart';
import '../signup_1/model/SignUpModel.dart';
import '/app/core/base/base_controller.dart';
import 'model/PendingBookingData.dart';

class HomeController extends BaseController {

  TextEditingController searchContoller = TextEditingController();

  final ProjectRepository _repository =
  Get.find(tag: (ProjectRepository).toString());

  RxBool isList = false.obs;

  RxInt isProfileApproved = 0.obs;
  RxInt isSetAvailability = 0.obs;
  RxString teacherName = "".obs;
  RxString noDataMessage = "".obs;


  final BottomNavController bottomNavController = Get.put(BottomNavController(), permanent: false);
  late SharedPreferences sharedPreferences;

  RxList<PendingBookingdata> pendingBookingList = <PendingBookingdata>[].obs;



  var isLoading = false.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;
  final int pageSize = 25;

  var isNotificationRead = 1.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    sharedPreferences = await SharedPreferences.getInstance();
    teacherName.value  = sharedPreferences.getString(SharePreferenceConst.full_name) ?? "";
   // isProfileApproved.value  = sharedPreferences.getInt(SharePreferenceConst.is_profile_approved) ?? 0;
   // isSetAvailability.value  = sharedPreferences.getInt(SharePreferenceConst.set_availability) ?? 0;
    callGetCheckAvailabilityService();
    callExtraDetailsService();
  }

  Future<void> callGetCheckAvailabilityService() async {

    var apiService = _repository.sendGetApiNoParamRequest(check_availability);

    callDataService(
        apiService,
        onSuccess: successResponseCheckAvailability,
        onError: handleOnError,
        isShowLoading: true
    );
  }

  Future<void> successResponseCheckAvailability(dynamic baseResponse) async {



    CheckAvailabilityModel response = CheckAvailabilityModel.fromJson(baseResponse.data);
    if(response.success == true){
      isProfileApproved.value  = response.data?.profileApprovedApp ?? 0;
      isSetAvailability.value  = response.data?.slotAvailability ?? 0;
      sharedPreferences.setInt(SharePreferenceConst.set_availability, response.data?.slotAvailability ?? 0);
      sharedPreferences.setString(SharePreferenceConst.timezone_text, response.data?.timezone_text ?? "");
      if(response.data?.slotAvailability == 1) {
        callGetPendingBooking();
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


  Future<void> callGetPendingBooking({int offset = 0}) async {

    if (offset == 0) {
      pendingBookingList.clear();
    }

    if (!isLoading.value && hasMoreData.value) {
      isLoading.value = true;

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["offset"] = offset;
        return data;
      }

      var apiService = _repository.sendPostApiRequest(
          toJson, get_pending_booking, true);

      callDataService(
          apiService,
          onSuccess: (baseResponse) => successResponsePendingBooking(baseResponse, offset),
          onError: handleOnErrorPendingBooking,
        isShowLoading: (offset == 0) ? true : false,
      );
      isLoading.value = false;
    }
  }

  Future<void> successResponsePendingBooking(dynamic baseResponse,int offset) async {

    PendingBookingModel response = PendingBookingModel.fromJson(baseResponse.data);
    if(response.success == true){
      noDataMessage.value = "";
      if (response.data!.length < pageSize) {
        hasMoreData.value = false; // No more data to load
      }

      if (offset == 0) {
        pendingBookingList.assignAll(response.data!); // First page load
      } else {
        pendingBookingList.addAll(response.data!); // Append for pagination
      }
    }

  }

  void handleOnErrorPendingBooking(dynamic e) {
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
      noDataMessage.value = e.response_msg;
      hasMoreData.value = false;
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
      isNotificationRead.value = response.is_notification_read!;
    }
  }


}


