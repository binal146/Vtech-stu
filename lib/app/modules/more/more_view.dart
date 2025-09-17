import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/core/utils/image.dart';
import 'package:vteach_teacher/app/core/values/text_styles.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/comman_text.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';
import 'more_controller.dart';

class MoreView extends BaseView<MoreController> {

  late Map<String, dynamic> data;

  List colors = [ const Color(0xFFfdf4e2),const Color(0xFFFEEBF7),const Color(0xFFE6FFFB),const Color(0xFFFEE7E3),];
  List colors2 = [ const Color(0xFFFBE8C6),const Color(0xFFFBD8EC),const Color(0xFFC8F6ED),const Color(0xFFFBD9D5),];

  MoreView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Container(height: 40.h,
          padding: EdgeInsets.only(left: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(AppText.more,
              style: appBarTitle,
              textAlign: TextAlign.center,
            ),
          ),),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
            
                SizedBox(height: 10.h,),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppText.notification_alert,style: blackPoppinsMedium14,),
                    Obx(() => (controller.isToggleOn.value) ? GestureDetector(
                        onTap: (){
                          //controller.isToggleOn.value = !controller.isToggleOn.value;
                          controller.callNotificationStatusService("0");
                        },
                        child: SvgPicture.asset(Drawables.toggle_on)) : GestureDetector(onTap: (){
                      //controller.isToggleOn.value = !controller.isToggleOn.value;
                      controller.callNotificationStatusService("1");
                    }, child: SvgPicture.asset(Drawables.toggle_off))),
                  ],
                ),
            
                SizedBox(height: 10.h,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.MY_PROFILE);
                  },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Clr.grey_border),
                        borderRadius: BorderRadius.circular(10),
                        color: Clr.viewBg
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppText.my_profile,style: blackPoppinsMedium14,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Clr.blackColor,)
                      ],
                    ),
                  ),
                ),
            
                SizedBox(height: 10.h,),
            
                Obx(() =>   (controller.setAvailability.value == 1) ?
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.AVAILABILITY,arguments: "1");
                  },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Clr.grey_border),
                        borderRadius: BorderRadius.circular(10),
                        color: Clr.viewBg
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppText.change_availability,style: blackPoppinsMedium14,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Clr.blackColor,)
                      ],
                    ),
                  ),
                ) : SizedBox(),),
            
                Obx(() => (controller.setAvailability == 1) ? SizedBox(height: 10.h,) : SizedBox(),),
            
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.WEB_VIEW,parameters:{"api" : about_app,} );
                  },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Clr.grey_border),
                      borderRadius: BorderRadius.circular(10),
                        color: Clr.viewBg
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppText.about_app,style: blackPoppinsMedium14,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Clr.blackColor,)
                      ],
                    ),
                  ),
                ),
            
                SizedBox(height: 10.h,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.WEB_VIEW,parameters:{"api" : term_and_condition,} );
                  },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Clr.grey_border),
                        borderRadius: BorderRadius.circular(10),
                        color: Clr.viewBg
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppText.terms_condition,style: blackPoppinsMedium14,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Clr.blackColor,)
                      ],
                    ),
                  ),
                ),
            
                SizedBox(height: 10.h,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.WEB_VIEW,parameters:{"api" : privacy_policy,} );
                  },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Clr.grey_border),
                        borderRadius: BorderRadius.circular(10),
                        color: Clr.viewBg
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppText.privacy,style: blackPoppinsMedium14,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Clr.blackColor,)
                      ],
                    ),
                  ),
                ),
            
                SizedBox(height: 10.h,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.CONTACT_US);
                  },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Clr.grey_border),
                        borderRadius: BorderRadius.circular(10),
                        color: Clr.viewBg
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppText.contact_us,style: blackPoppinsMedium14,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Clr.blackColor,)
                      ],
                    ),
                  ),
                ),
            
                SizedBox(height: 10.h,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(Routes.CHANGE_PASSWORD);
                  },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Clr.grey_border),
                        borderRadius: BorderRadius.circular(10),
                        color: Clr.viewBg
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppText.change_password,style: blackPoppinsMedium14,),
                        Icon(Icons.arrow_forward_ios_outlined,color: Clr.blackColor,)
                      ],
                    ),
                  ),
                ),
            
                SizedBox(height: 10.h,),
                GestureDetector(
                  onTap : (){
                    showLogoutDialog(context);
                },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Clr.grey_border),
                        borderRadius: BorderRadius.circular(10),
                        color: Clr.viewBg
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppText.logout,style: TextStyle(
                            fontSize: 14.sp,
                            color: Clr.redColor,
                            fontFamily: Fonts.PoppinsMedium),),
                      ],
                    ),
                  ),
                ),
              ],),
            ),
          ),
        ),
      ],
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title:  Text(AppText.logout,style: TextStyle(fontSize: 14.sp,fontFamily: Fonts.PoppinsMedium,color: Clr.black),),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(AppText.logout_msg,style:TextStyle(fontSize: 12.sp,fontFamily: Fonts.PoppinsMedium,color: Clr.greyColor) ,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(AppText.yes),
              onPressed: () async {
                controller.callLogoutService();
                Get.back();
              },
            ),
            TextButton(
              child:  Text(AppText.no),
              onPressed: () {

                Get.back();

              },
            )
          ],
        ));
  }

}
