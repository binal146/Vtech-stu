import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/utils/api_services.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/constants.dart';
import '/app/core/base/base_controller.dart';

class WebviewController extends BaseController {

  late String apiName;
  String url = "";
  RxBool isLoading = false.obs;

  RxString title = "".obs;
  late WebViewController controller; // Declare as late

  @override
  Future<void> onInit() async {
    super.onInit();


    apiName = Get.parameters['api'].toString();
    String baseUrl = "";
    if(Constants.isProduction){
      baseUrl = baseUrlProd;
    }else{
      baseUrl = baseUrlDev;
    }

    if(apiName == "term_and_condition"){
      title.value = AppText.terms_and_conditions;
    }else if(apiName == "privacy_policy"){
      title.value = AppText.privacy_policy;
    }else if(apiName == "about_app"){
      title.value = AppText.about_app;
    }

    url = "${baseUrl}${apiName}";



    showLoading();
    // Initialize the controller here
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {

          },
          onPageStarted: (String url) {
            // You can add additional loading logic here if needed
          },
          onPageFinished: (String url) {
            hideLoading();
            isLoading.value = true;
          },
          onWebResourceError: (WebResourceError error) {
            // Handle the error
            isLoading.value = true;
          },
          onNavigationRequest: (NavigationRequest request) {
            /*if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }*/
            return NavigationDecision.navigate;
          },
        ),
      );

    // Load the URL after initializing the controller
    /*controller.loadRequest(
      Uri.parse(url),
      method: LoadRequestMethod.get,
    );*/

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadRequest(
        Uri.parse(url),
      );
    });





  }

}
