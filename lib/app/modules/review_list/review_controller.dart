import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/utils/api_services.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/not_found_exception.dart';
import '/app/core/base/base_controller.dart';
import 'model/RateData.dart';
import 'model/RateModel.dart';

class ReviewController extends BaseController {

  TextEditingController searchContoller = TextEditingController();

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());

  RxList<RateData> reviewList = <RateData>[].obs;
  RxString noDataMessage = "".obs;

  RxString rating = "".obs;
  RxString totalReview = "".obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    rating.value = Get.parameters['rating']!;
    totalReview.value = Get.parameters['total_review']!;
    callGetReviewListService();
  }

  Future<void> callGetReviewListService() async {
    reviewList.clear();

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      return data;
    }

    var apiService = _repository.sendPostApiRequest(toJson,rating_listing,false);

    callDataService(
      apiService,
      onSuccess: successResponse,
      onError: handleOnError,
      isShowLoading: true,
    );
  }

  Future<void> successResponse(dynamic baseResponse) async {
    RateModel response = RateModel.fromJson(baseResponse.data);
    if(response.success == true){
      reviewList.addAll(response.data!);
    }
  }

  void handleOnError(dynamic e) {
    if(e is NotFoundException){
      noDataMessage.value = e.response_msg;
      reviewList.clear();
    }
  }

}


