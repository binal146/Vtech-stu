import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/appoint_success/appoint_success_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';


class AppointSuccessView extends BaseView<AppointSuccessController> {
  AppointSuccessView({super.key});


  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            ],),),

          SizedBox(height: 40.h,),

          SvgPicture.asset(Drawables.success_tick,
            height: 80.h,
            width: 80.h,),

          SizedBox(height: 10.h,),
          
          Text(AppText.woohoo,style:blackPoppinsMedium27),

          SizedBox(height: 5.h,),

          Text(AppText.you_have_successfully_ended_your_session,textAlign: TextAlign.center,style: blackPoppinsMedium17),

          SizedBox(height: 40.h,),

          
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 40),
            decoration: BoxDecoration(
            color: Clr.green400,
            borderRadius: BorderRadius.circular(15)
          ),
          child: Column(children: [

          SizedBox(
          height: 100.0,
            width: 100.0,
            child: Image.asset(
             Drawables.dummy5, // Replace with your SVG path
              fit: BoxFit.cover,
            ),
          ),

            SizedBox(height: 5.h,),
            Text(AppText.student_name,style: TextStyle(
                fontSize: 12.sp,
                color: Clr.greyColor,
                fontFamily: Fonts.PoppinsRegular),),

            SizedBox(height: 5.h,),
            Text("John Smith",style: blackPoppinsMedium16),

            SizedBox(height: 5.h,),

            Text("Grade: 7",style: blackPoppinsRegularr12),

            SizedBox(height: 5.h,),

            Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Clr.green200,
                    borderRadius: BorderRadius.all(Radius.circular(14))
                ),
                child: Text('Biology',style: blackPoppinsMedium12 ,)),

            SizedBox(height: 5.h,),
            Text("15 May,2024 - 22 May,2024",style:blackPoppinsRegularr14,),


          ],),)
          
        ],
      ),
    );
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return  Container(
      width: double.infinity,
      margin: EdgeInsets.all(15),
      height: 45.h,
      child: ElevatedButton(
        onPressed: () {
          Get.offAllNamed(Routes.BOTTOM_NAV_BAR);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Clr.appColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),),
        ),
        child: Text(AppText.go_to_home,style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
      ),
    );
  }


}
