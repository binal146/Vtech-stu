import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/splash/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController(),);
  }
}
