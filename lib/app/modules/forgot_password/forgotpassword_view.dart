import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/forgot_password/forgotpassword_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/utils/keyboard_types.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../core/widget/comman_textfield.dart';
import '/app/core/base/base_view.dart';


class ForgotPasswordView extends BaseView<ForgotPasswordController> {
  ForgotPasswordView({super.key});


  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
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
            Text(AppText.forgot_your_password_cap,
              style: appBarTitle,
              textAlign: TextAlign.center,
            )
          ],),),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
          
                      SizedBox(height: 50.h,),
          
                      SvgPicture.asset(Drawables.forgot,height: 60.h,width: 60.w,),
                      SizedBox(height: 20.h,),
                      Text(
                        AppText.forgot_pass_msg,
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                            fontSize: 14.sp,
                            color: Clr.greyColor,
                            fontFamily: Fonts.PoppinsRegular),
                      ),
                      SizedBox(height: 20.h,),
                      CommanTextField(
                        hint: "",
                        label: AppText.email,
                        keyboardType: KeyboardComman.EMAIL,
                        inputAction: KeyboardComman.NEXT,
                        maxlines: 1,
                        controller: controller.emailController,
                      ),
                      SizedBox(height: 20.h,),
          
                    ],),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45.h,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.forgotPassword();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Clr.appColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),),
                    ),
                    child: Text(AppText.submit,style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ],
    );
  }



}
