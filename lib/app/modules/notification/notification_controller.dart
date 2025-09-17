import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/notification/model/NotificationModel.dart';
import '../../core/utils/api_services.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/not_found_exception.dart';
import '/app/core/base/base_controller.dart';
import 'model/NotificationData.dart';

class NotificationController extends BaseController {

  TextEditingController searchContoller = TextEditingController();

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());

  RxList<NotificationData> notificationList = <NotificationData>[].obs;
  RxString noDataMessage = "".obs;

  var isLoading = false.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;
  final int pageSize = 25;

  @override
  Future<void> onInit() async {
    super.onInit();
    callGetNotificationListService();
  }


  Future<void> callGetNotificationListService({int offset = 0}) async {
    if (offset == 0) {
      notificationList.clear(); // Clear data only for first load
    }

    if (!isLoading.value && hasMoreData.value) {
      isLoading.value = true;

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['offset'] = offset;
        return data;
      }

      var apiService = _repository.sendPostApiRequest(toJson, notification_listing, false);

      await callDataService(
        apiService,
        onSuccess: (baseResponse) => successResponse(baseResponse, offset),
        onError: (baseError) => handleOnError(baseError, offset),
        isShowLoading: (offset == 0) ? true : false,
      );

      isLoading.value = false;
    }
  }

  Future<void> successResponse(dynamic baseResponse, int offset) async {
    NotificationModel response = NotificationModel.fromJson(baseResponse.data);

    if (response.success == true) {
      if (response.data!.length < pageSize) {
        hasMoreData.value = false; // No more data to load
      }

      if (offset == 0) {
        notificationList.assignAll(response.data!); // First page load
      } else {
        notificationList.addAll(response.data!); // Append for pagination
      }
    }
  }

  void handleOnError(dynamic e,int offset) {
    if (e is NotFoundException) {
      noDataMessage.value = e.response_msg;
      if(offset == 0) {
        notificationList.clear();
      }
      hasMoreData.value = false;
    }
  }

/*  Future<void> callGetNotificationListService() async {
    notificationList.clear();

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,notification_listing,false);

    callDataService(
      apiService,
      onSuccess: successResponse,
      onError: handleOnError,
      isShowLoading: true,
    );
  }

  Future<void> successResponse(dynamic baseResponse) async {
    NotificationModel response = NotificationModel.fromJson(baseResponse.data);
    if(response.success == true){
      notificationList.assignAll(response.data!);
    }
  }

  void handleOnError(dynamic e) {
    if(e is NotFoundException){
      noDataMessage.value = e.response_msg;
      notificationList.clear();
    }
  }*/

}


