import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../network/exceptions/api_exception.dart';
import '../../network/exceptions/app_exception.dart';
import '../../network/exceptions/json_format_exception.dart';
import '../../network/exceptions/network_exception.dart';
import '../../network/exceptions/not_found_exception.dart';
import '../../network/exceptions/service_unavailable_exception.dart';
import '../../network/exceptions/unauthorize_exception.dart';
import '../../routes/app_pages.dart';
import '../utils/colour.dart';
import '../utils/common_widgets.dart';
import '../values/comman_text.dart';
import '/app/core/model/page_state.dart';
import '/flavors/build_config.dart';


abstract class BaseController extends GetxController {

  final Logger logger = BuildConfig.instance.config.logger;

  final logoutController = false.obs;

  //Reload the page
  final _refreshController = false.obs;

  refreshPage(bool refresh) => _refreshController(refresh);

  //Controls page state
  final _pageSateController = PageState.DEFAULT.obs;

  PageState get pageState => _pageSateController.value;

  updatePageState(PageState state) => _pageSateController(state);

  resetPageState() => _pageSateController(PageState.DEFAULT);

  showLoading() => updatePageState(PageState.LOADING);

  showShimmer() => updatePageState(PageState.LOADING_SHIMMER);

  hideLoading() => resetPageState();

  hideShimmer() => resetPageState();

  final _messageController = ''.obs;

  String get message => _messageController.value;

  showMessage(String msg) => _messageController(msg);

  final _errorMessageController = ''.obs;

  String get errorMessage => _errorMessageController.value;

  showErrorMessage(String msg) {
    _errorMessageController(msg);
  }

  final _successMessageController = ''.obs;


  String get successMessage => _messageController.value;

  showSuccessMessage(String msg) => _successMessageController(msg);


  // ignore: long-parameter-list
  dynamic callDataService<T>(
    Future<T> future, {
    Function(Exception exception)? onError,
    Function(T response)? onSuccess,
    Function? onStart,
    Function? onComplete,
        bool? isShowLoading,
        bool isShimmerShow = false,
        bool isHide = true,
  }) async {
    Exception? _exception;

    onStart == null ? (isShowLoading == true) ? showLoading() : hideLoading() : onStart();

    if(isShimmerShow) {
      onStart == null
          ? (isShimmerShow == true) ? showShimmer() : hideShimmer()
          : onStart();
    }

    try {
      final T response = await future;

      if (onSuccess != null) onSuccess(response);

      onComplete == null ? (isHide == true) ? hideLoading() : showLoading() : onComplete();

      if(isShimmerShow) {
        onComplete == null
            ? (isHide == true) ? hideShimmer() : showShimmer()
            : onComplete();
      }

      return response;
    } on ServiceUnavailableException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.response_msg);
    } on UnauthorizedException catch (exception) {
      _exception = exception;
      //showErrorMessage(exception.response_msg);
      CommonUtils.commonUtils?.toastMessage(exception.response_msg);
      await unauthorizedUser();
    } on TimeoutException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.message ?? 'Timeout exception');
    } on NetworkException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.response_msg);
      CommonUtils.commonUtils?.toastMessage(exception.response_msg);
    } on JsonFormatException catch (exception) {
      _exception = exception;
      showErrorMessage(exception.response_msg);
    } on NotFoundException catch (exception) {
      _exception = exception;
      //showErrorMessage(exception.message);
    } on ApiException catch (exception) {
      _exception = exception;
      if(exception.httpCode == 401){
        //unauthorizedUser();
      }
    } on AppException catch (exception) {
      _exception = exception;
      //showErrorMessage(exception.message);
    } catch (error) {
      _exception = AppException(httpCode:-1,response_msg: "$error");
      logger.e("Controller>>>>>> error $error");
    }

    if (onError != null) onError(_exception);

    onComplete == null ? (isHide == true) ? hideLoading() : showLoading() : onComplete();

    if(isShimmerShow) {
      onComplete == null
          ? (isHide == true) ? hideShimmer() : showShimmer()
          : onComplete();
    }
  }

  Future<void> unauthorizedUser() async {
    SharedPreferences sharePref = await SharedPreferences.getInstance();
    sharePref.clear();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    _messageController.close();
    _refreshController.close();
    _pageSateController.close();
    super.onClose();
  }

}

