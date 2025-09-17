import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/webview/webview_controller.dart';

class WebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebviewController>(() => WebviewController(),);
  }
}
