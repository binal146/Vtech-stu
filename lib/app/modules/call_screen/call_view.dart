import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';
import 'call_controller.dart';


class CallView extends BaseView<CallController> {

  CallView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 100.sp,
                    child: Obx(() => Column(
                      children: [

                        Text("Incoming call….",
                          textAlign: TextAlign.center,
                          style:  TextStyle(
                              fontSize: 20.sp,
                              color: Clr.blackColor,
                              fontFamily: Fonts.PoppinsSemiBold),),

                        SizedBox(height: 30.h,),

                        Text(controller.callerName.value.toString(),
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                                fontSize: 14.sp,
                                color: Clr.blackColor,
                                fontFamily: Fonts.PoppinsSemiBold),),
                      ],
                    ),),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
/*                        ElevatedButton(onPressed: () {
                          controller.bottomNavController.callActionVCallService('accept');
                          Get.offNamed(Routes.AGORA_DEMO,arguments: controller.notificationModel);
                        }, child: Text('Accept')),
                        SizedBox(width: 30.w,),
                        ElevatedButton(onPressed: () {
                          controller.bottomNavController.callActionVCallService('decline');
                          Get.back();
                        }, child: Text('Decline')),*/

                        InkWell(
                          onTap: (){
                            /*controller.bottomNavController.callActionVCallService('accept');
                            Get.offNamed(Routes.AGORA_DEMO,arguments: controller.notificationModel);*/
                            controller.checkPermissions();
                          },
                          child: Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Clr.green
                            ),
                            child: Icon(Icons.call,color: Clr.white,size: 30.sp,),
                          ),
                        ),
                        InkWell(
                          onTap: (){
/*                            controller.bottomNavController.callActionVCallService('decline',"");
                            Get.back();*/
                            controller.callActionVCallService('decline',"");
                          },
                          child: Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Clr.redDark
                            ),
                            child: Icon(Icons.call_end,color: Clr.white,size: 30.sp,),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
