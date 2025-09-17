import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/history/model/TransactionHistoryData.dart';
import 'package:vteach_teacher/app/modules/history/model/TransactionHistoryModel.dart';
import '../../core/utils/api_services.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/not_found_exception.dart';
import '/app/core/base/base_controller.dart';
import 'model/Years.dart';

class HistoryController extends BaseController {

  TextEditingController searchContoller = TextEditingController();

  final ProjectRepository _repository =
  Get.find(tag: (ProjectRepository).toString());

  //RxList<TransactionHistoryData> transactionList = <TransactionHistoryData>[].obs;

  RxList<TransactionHistoryData> monthList = <TransactionHistoryData>[].obs;

  RxString noDataMessage = "".obs;

  var isLoading = false.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;
  final int pageSize = 25;

  List<String> yearsOld = ['2022', '2023', '2024', '2025', '2026'];
  RxList<Years> years = <Years>[].obs;
  RxString selectedYear = ''.obs;
  RxString totalEarned = '0.0'.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    selectedYear.value = DateTime.now().year.toString();
    callTransactionHistoryService();
  }

  Future<void> callTransactionHistoryService({int offset = 0}) async {
    if (offset == 0) {
      monthList.clear(); // Clear data only for first load
    }

    if (!isLoading.value && hasMoreData.value) {
      isLoading.value = true;

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['offset'] = offset;
        data['year'] = selectedYear.value.toString();
        return data;
      }

      var apiService = _repository.sendPostApiRequest(toJson, transaction_history, false);

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
    TransactionHistoryModel response = TransactionHistoryModel.fromJson(baseResponse.data);

    if (response.success == true) {
      totalEarned.value = response.total_earnings.toString();
      years.value = response.years!;

      for(var value in response.years!){
        if(value.is_default == 1){
          //selectedYear.value = value.year.toString();
        }
      }
      if (response.data!.length < pageSize) {
        hasMoreData.value = false; // No more data to load
      }

      if (offset == 0) {
        monthList.assignAll(response.data!); // First page load
      } else {
        monthList.addAll(response.data!); // Append for pagination
      }
    }else{
      years.value = response.years!;
      noDataMessage.value = response.responseMsg.toString();
      totalEarned.value = "0.0";
      if(offset == 0) {
        monthList.clear();
      }
      hasMoreData.value = false;
    }
  }

  void handleOnError(dynamic e,int offset) {
    if (e is NotFoundException) {
      noDataMessage.value = e.response_msg;
      totalEarned.value = "0.0";
      if(offset == 0) {
        monthList.clear();
      }
      hasMoreData.value = false;
    }
  }

}


