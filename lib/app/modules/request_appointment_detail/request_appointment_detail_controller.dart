import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:vteach_teacher/app/core/base/BaseModel.dart';
import 'package:vteach_teacher/app/core/utils/common_widgets.dart';
import 'package:vteach_teacher/app/modules/request_appointment_detail/model/CancelReasonData.dart';
import 'package:vteach_teacher/app/modules/request_appointment_detail/model/CancelReasonModel.dart';
import 'package:vteach_teacher/app/modules/request_appointment_detail/model/RequestDetailData.dart';
import 'package:vteach_teacher/app/modules/request_appointment_detail/model/RequestDetailModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/comman_text.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/not_found_exception.dart';
import '/app/core/base/base_controller.dart';

class RequestAppointmentDetailController extends BaseController {

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());


  String appointmentType = "";
  RxInt selectedValue = 0.obs;
  late var pendingBookingdata = Rxn<RequestDetailData>();
  String bookingId = "";

  RxList<DateTime> bookedDateList = <DateTime>[].obs;
  RxList<CancelReasonData> reasonList = <CancelReasonData>[].obs;
  RxString? initialSelectedDate = ''.obs;
  RxList<DateTime> availableDateList = <DateTime>[].obs;

  final reasonController = TextEditingController();

  RxBool isLoading = true.obs;

  List<String> selectedTimeslotIds = [];
  List<String> unselectedTimeslotIds = [];
  List<String> allSelectedTimeslotIds = [];
  String accept_slot_ids = "";
  String reject_slot_ids = "";

  RxBool isNoData = false.obs;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  String fromNotification = "";

  @override
  Future<void> onInit() async {
    super.onInit();
    bookingId = Get.arguments;
    fromNotification = Get.parameters['fromNotification']!;
 /*   for(var date in bookingData.bookedDays!){
      bookedDateList.add(DateTime.parse(date.days.toString()));
    }*/
    callGetBookingDetailService();
    callGetCancelReasonListService();
  }

  Future<void> callGetBookingDetailService() async {

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['booking_id'] = bookingId;
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,get_pending_booking_details,false);

    callDataService(
      apiService,
      onSuccess: successResponse,
      onError: handleOnErrorBookingDetail,
      isShowLoading: true,
    );
  }

  Future<void> successResponse(dynamic baseResponse) async {
    isLoading.value = false;
    RequestDetailModel response = RequestDetailModel.fromJson(baseResponse.data);
    if(response.success == true){
     pendingBookingdata.value = response.data;

     initialSelectedDate!.value = response.data!.startDate.toString();

 /*    List<String> dates = generateDateList(response.data!.startDate.toString(),response.data!.endDate.toString());
     for(var date in dates){
       availableDateList.add(DateTime.parse(date.toString()));
     }*/
    }

  }

  Future<void> callAcceptRejectService(String status,String reason,BuildContext context2) async {
    selectedTimeslotIds = [];
    unselectedTimeslotIds = [];
    allSelectedTimeslotIds = [];
    for(int i=0; i<pendingBookingdata.value!.datetimeSlotsmodel!.length; i++){
      for(int j=0; j<pendingBookingdata.value!.datetimeSlotsmodel![i].timeslots!.length; j++){
        String booking_slot_id = pendingBookingdata.value!.datetimeSlotsmodel![i].timeslots![j].booking_slot_id.toString();
        String  timeslot = pendingBookingdata.value!.datetimeSlotsmodel![i].timeslots![j].time.toString();
        bool isSelected = false;
        if(pendingBookingdata.value!.datetimeSlotsmodel![i].timeslots![j].is_cancel == 0) {
          isSelected = pendingBookingdata.value!.datetimeSlotsmodel![i].timeslots![j].isSelect.value;
        }
        allSelectedTimeslotIds.add(booking_slot_id);
        if(isSelected){
          selectedTimeslotIds.add(booking_slot_id);
        }else{
          if(pendingBookingdata.value!.datetimeSlotsmodel![i].timeslots![j].is_cancel == 0) {
            unselectedTimeslotIds.add(booking_slot_id);
          }
        }
      }
    }

    if(status == 'accept'){
      accept_slot_ids = selectedTimeslotIds.join(',');
      reject_slot_ids = unselectedTimeslotIds.join(',');
    }else{
      //reject_slot_ids = selectedTimeslotIds.join(',');
      reject_slot_ids = allSelectedTimeslotIds.join(',');
      accept_slot_ids = unselectedTimeslotIds.join(',');
    }

    print("accept_slot_ids"+accept_slot_ids);
    print("reject_slot_ids"+reject_slot_ids);

    if(status == "accept") {
      if(accept_slot_ids.isEmpty){
        CommonUtils.getIntance().toastMessage(AppText.accept_request_msg);
      }else{
        showConfirmAcceptDialog(Get.context!,status,reason);
      }
    }else {
      if(reject_slot_ids.isEmpty){
        CommonUtils.getIntance().toastMessage(AppText.reject_request_msg);
      }else{
        print("AAAAAAAAAAAAAAAAAAAAA");

        if (Get.context != null) {
          print("Get.context is not null");
         // showConfirmRejectDialog(Get.context!, status, reason);
          Future.delayed(Duration.zero, () {
            showConfirmRejectDialog(context2, status, reason);
          });
        } else {
          print("Get.context is null");
        }
      }
    }
  }

  void acceptRejectService(String status, String reason) {
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['booking_id'] = bookingId;
      if(status == "accept"){
        data['accept_slot_ids'] = accept_slot_ids;
      }
      data['reject_slot_ids'] = reject_slot_ids;
      if(status == "reject"){
        if(reason.isNotEmpty){
        data['reject_reason'] = reason;
        }
      }
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,accept_reject_booking,false);

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
      flutterLocalNotificationsPlugin.cancel(int.parse(bookingId));
    }
  }

  void handleOnErrorBookingDetail(dynamic e) {
    isLoading.value = false;
    if(e is NotFoundException){
      isNoData.value = true;
      CommonUtils.getIntance().toastMessage(e.response_msg);
    }
  }

  void handleOnError(dynamic e) {
    if(e is NotFoundException){
      CommonUtils.getIntance().toastMessage(e.response_msg);
    }
  }

  List<String> generateDateList(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    List<String> dateList = [];

    while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
      dateList.add(DateFormat('yyyy-MM-dd').format(start));
      start = start.add(Duration(days: 1));
    }

    return dateList;
  }

  Future<void> callGetCancelReasonListService() async {

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['reason_type'] = "rejectreuqest";
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

  void showConfirmAcceptDialog(BuildContext context,String status,String reason) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title:  Text(AppText.accept,style: TextStyle(fontSize: 14.sp,fontFamily: Fonts.PoppinsMedium,color: Clr.black),),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(AppText.accept_msg,style:TextStyle(fontSize: 12.sp,fontFamily: Fonts.PoppinsMedium,color: Clr.greyColor) ,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(AppText.yes),
              onPressed: () async {
                acceptRejectService(status, reason);
                Get.back();
              },
            ),
            TextButton(
              child:  Text(AppText.no),
              onPressed: () {
                Get.back();
              },
            )
          ],
        ));
  }


  void showConfirmRejectDialog(BuildContext context1,String status,String reason) {
    showDialog<String>(
        context: context1,
        builder: (BuildContext context) => AlertDialog(
          title:  Text(AppText.reject,style: TextStyle(fontSize: 14.sp,fontFamily: Fonts.PoppinsMedium,color: Clr.black),),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(AppText.reject_msg,style:TextStyle(fontSize: 12.sp,fontFamily: Fonts.PoppinsMedium,color: Clr.greyColor) ,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(AppText.yes),
              onPressed: () async {
                acceptRejectService(status, reason);
                Get.back();
              },
            ),
            TextButton(
              child:  Text(AppText.no),
              onPressed: () {
                Get.back();
              },
            )
          ],
        ));
  }


}
