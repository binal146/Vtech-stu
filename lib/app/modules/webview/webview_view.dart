import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/webview/webview_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/utils/colour.dart';
import '../../core/values/text_styles.dart';
import '/app/core/base/base_view.dart';

class WebView extends BaseView<WebviewController> {
  WebView({super.key});


  @override
  PreferredSizeWidget? appBar(BuildContext context){
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return  Column(
      children: [
        Container(height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(children: [
            InkWell(
              onTap: (){
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Clr.backButtonBg
                ),
                child: Icon(Icons.arrow_back_ios_new_outlined),
              ),
            ),
            SizedBox(width: 10.w,),
            Obx(() => Text(controller.title.value,
              style: appBarTitle,
              textAlign: TextAlign.center,
            ),)
          ],),),
        Obx(() => (controller.isLoading.value == true) ? Expanded(child: Container(
            color: Clr.white,
            margin: EdgeInsets.all(20),
            child: WebViewWidget(controller: controller.controller,
            ))) : SizedBox(),),
      ],
    );
  }

}
