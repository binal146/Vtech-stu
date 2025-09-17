import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:vteach_teacher/app/modules/call_details/model/CallDetailModel.dart';
import '../../core/utils/api_services.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/not_found_exception.dart';
import '/app/core/base/base_controller.dart';
import 'model/CallDetails.dart';

class CallDetailController extends BaseController with GetSingleTickerProviderStateMixin {

  RxBool isUpcoming = true.obs;
  RxInt selectedFilter = 0.obs;
  RxBool isFilterApply = false.obs;

  RxString emptyMessage = "".obs;
  String bookingSlotId = "";

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());
  RxList<CallDetails> callDetailList = <CallDetails>[].obs;

  var isLoading = false.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;
  final int pageSize = 25;

  @override
  Future<void> onInit() async {
    super.onInit();
    bookingSlotId = Get.arguments.toString();
    callGetBookingCallHistoryService();
  }

  Future<void> callGetBookingCallHistoryService({int offset = 0}) async {

    if (offset == 0) {
      callDetailList.clear();
    }

    if (!isLoading.value && hasMoreData.value) {
      isLoading.value = true;

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['booking_slot_id'] = bookingSlotId;
        data['offset'] = offset;
        return data;
      }

      var apiService = _repository.sendPostApiRequest(
          toJson, get_booking_call_history, false);

      callDataService(
        apiService,
        onSuccess: (baseResponse) => successResponse(baseResponse, offset),
        onError: (errorResponse) => handleOnError(errorResponse, offset),
        isShowLoading: (offset == 0) ? true : false,
      );

      isLoading.value = false;
    }
  }


  Future<void> successResponse(dynamic baseResponse,int offset) async {
    CallDetailModel response = CallDetailModel.fromJson(baseResponse.data);
    if(response.success == true){
      emptyMessage.value = "";
      if (response.callDetails!.length < pageSize) {
        hasMoreData.value = false; // No more data to load
      }

      if (offset == 0) {
        callDetailList.assignAll(response.callDetails!); // First page load
      } else {
        callDetailList.addAll(response.callDetails!); // Append for pagination
      }
    }
  }

  void handleOnError(dynamic e,int offset) {
    if(e is NotFoundException){
      emptyMessage.value = e.response_msg;
      if(offset == 0){
        callDetailList.clear();
      }
      hasMoreData.value = false;
    }
  }
}


