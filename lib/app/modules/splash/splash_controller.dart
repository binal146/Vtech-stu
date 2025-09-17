import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/values/sharePrefrenceConst.dart';
import '../../data/repository/project_repository.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_controller.dart';

class SplashController extends BaseController {

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());


  @override
  Future<void> onInit() async {
    super.onInit();
    bool? isLogin = false;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isLogin = sharedPreferences.getBool(SharePreferenceConst.isLogin);

    Timer(const Duration(seconds: 1), () async {
      if(isLogin == true){
        Get.offNamed(Routes.BOTTOM_NAV_BAR);
      }else{
        Get.offNamed(Routes.LOGIN);
      }
    });
  }

}
