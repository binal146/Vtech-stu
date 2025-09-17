import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:vteach_teacher/app/core/base/base_view.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/values/comman_text.dart';
import 'BottomNavController.dart';

class BottomNavView extends BaseView<BottomNavController> {

  DateTime? currentBackPressTime;

  BottomNavView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }


  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(1),
        //initialRoute: (Constants.currentTab == 1) ? '/menu' : (Constants.currentTab == 2) ? '/checkout' : (Constants.currentTab == 3) ? '/profile' : '/home' ,
        initialRoute: '/home' ,
        onGenerateRoute: controller.onGenerateRoute,
      ),
      bottomNavigationBar:Container(
        height: 55.h,
        color: Clr.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Obx(() => (controller.currentIndex.value == 0) ? InkWell(
              onTap: (){
                controller.changePage(0);
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Clr.appColor,
                    borderRadius: BorderRadius.circular(24)
                ),
                child: Row(children: [
                  SvgPicture.asset(Drawables.home_unselect,color: Clr.white,height: 24,width: 24,),
                  SizedBox(width: 2.w,),
                  Text(AppText.home,style: TextStyle(
                      fontSize: 14.sp,
                      color: Clr.white,
                      fontFamily: Fonts.PoppinsMedium),)
                ],),
              ),
            ) : InkWell(
              onTap: (){
                controller.changePage(0);
              },
                child: SvgPicture.asset(Drawables.home_unselect,color: Colors.grey,height: 24,width: 24,)),),


            Obx(() => (controller.currentIndex.value == 1) ? InkWell(
              onTap: (){
                controller.changePage(1);
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Clr.appColor,
                    borderRadius: BorderRadius.circular(24)
                ),
                child: Row(children: [
                  SvgPicture.asset(Drawables.appoinments_unselect,color: Clr.white,height: 24,width: 24,),
                  SizedBox(width: 2.w,),
                  Text(AppText.appoinments,style: TextStyle(
                      fontSize: 14.sp,
                      color: Clr.white,
                      fontFamily: Fonts.PoppinsMedium),)
                ],),
              ),
            ) : InkWell(
                onTap: (){
                  controller.changePage(1);
                },
                child: SvgPicture.asset(Drawables.appoinments_unselect,color: Colors.grey,height: 24,width: 24,)),),

            Obx(() => (controller.currentIndex.value == 2) ? InkWell(
              onTap: (){
                controller.changePage(2);
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Clr.appColor,
                    borderRadius: BorderRadius.circular(24)
                ),
                child: Row(children: [
                  SvgPicture.asset(Drawables.history_unselect,color: Clr.white,height: 24,width: 24,),
                  SizedBox(width: 2.w,),
                  Text(AppText.history,style: TextStyle(
                      fontSize: 14.sp,
                      color: Clr.white,
                      fontFamily: Fonts.PoppinsMedium),)
                ],),
              ),
            ) : InkWell(
                onTap: (){
                  controller.changePage(2);
                },
                child: SvgPicture.asset(Drawables.history_unselect,color: Colors.grey,height: 24,width: 24,)),),


            Obx(() => (controller.currentIndex.value == 3) ? InkWell(
              onTap: (){
                controller.changePage(3);
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Clr.appColor,
                    borderRadius: BorderRadius.circular(24)
                ),
                child: Row(children: [
                  SvgPicture.asset(Drawables.more_unselect,color: Clr.white,height: 24,width: 24,),
                  SizedBox(width: 2.w,),
                  Text(AppText.more,style: TextStyle(
                      fontSize: 14.sp,
                      color: Clr.white,
                      fontFamily: Fonts.PoppinsMedium),)
                ],),
              ),
            ) : InkWell(
                onTap: (){
                  controller.changePage(3);
                },
                child: SvgPicture.asset(Drawables.more_unselect,color: Colors.grey,height: 24,width: 24,)),),


          ],
        ),
      ),
    );
  }

  final TextStyle unselectedLabelStyle = TextStyle(
      color: Clr.greyTextDark,
      fontFamily: Fonts.PoppinsSemiBold,
      fontSize: 12.sp);

  TextStyle selectedLabelStyle = TextStyle(
      color: Clr.black,
      fontFamily: Fonts.PoppinsSemiBold,
      fontSize: 12.sp);
}



