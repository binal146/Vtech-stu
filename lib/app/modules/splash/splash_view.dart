import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vteach_teacher/app/modules/splash/splash_controller.dart';

import '../../core/utils/colour.dart';
import '../../core/utils/image.dart';
import '/app/core/base/base_view.dart';

class SplashView extends BaseView<SplashController> {
  SplashView({super.key});


  @override
  PreferredSizeWidget? appBar(BuildContext context){
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Clr.white,
      child: SvgPicture.asset(Drawables.splash_bg_1, fit: BoxFit.fill,),
    );
  }

}
