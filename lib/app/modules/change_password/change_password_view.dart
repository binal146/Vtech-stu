import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/utils/keyboard_types.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../core/widget/comman_textfield.dart';
import '/app/core/base/base_view.dart';
import 'change_password_controller.dart';


class ChangePasswordView extends BaseView<ChangePasswordController> {

  bool isAddtoCart = false;

  ChangePasswordView({super.key});

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
            Text(AppText.change_password.toUpperCase(),
              style: appBarTitle,
              textAlign: TextAlign.center,
            )
          ],),),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              color: Clr.white,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
          
                      SizedBox(
                        height: 30,
                      ),
          
                      Obx(() => CommanTextField(hint:"",label : AppText.old_password,keyboardType:KeyboardComman.PASSWORD,inputAction:KeyboardComman.NEXT,maxlines:1,isPassword:controller.isPasswordVisible.value,controller: controller.oldPasswordController,sufixIcon: passwordVisible(),),),
          
                       SizedBox(
                        height: 20,
                      ),
          
                      Obx(() => CommanTextField(hint:"",label : AppText.new_password,keyboardType:KeyboardComman.PASSWORD,inputAction:KeyboardComman.NEXT,maxlines:1,isPassword:controller.isNewPasswordVisible.value,controller: controller.newPasswordController,sufixIcon: newPasswordVisible(),),),
          
          
                      SizedBox(
                        height: 20,
                      ),
          
                      Obx(() => CommanTextField(hint:"",label : AppText.confirm_new_password,keyboardType:KeyboardComman.PASSWORD,inputAction:KeyboardComman.DONE,maxlines:1,isPassword:controller.isConfirmPasswordVisible.value,controller: controller.confirmNewPasswordController,sufixIcon: confirmPasswordVisible(),),),
          
          
                    ],),
          
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: 45.h,
      margin: EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: () {
         controller.changePasswordService();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Clr.appColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),),
        ),
        child: Text(AppText.change.toUpperCase(),style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
      ),
    );
  }

  Widget passwordVisible() {
    return InkWell(
      onTap: (){
        controller.isPasswordVisible.value =
        !controller.isPasswordVisible.value;
      },
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: (controller.isPasswordVisible.value == false) ? SvgPicture.asset(Drawables.open_eye,) : SvgPicture.asset(Drawables.close_eye,)),
    );
  }

  Widget newPasswordVisible() {
    return InkWell(
      onTap: (){
        controller.isNewPasswordVisible.value =  !controller.isNewPasswordVisible.value;
      },
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: (controller.isNewPasswordVisible.value == false) ? SvgPicture.asset(Drawables.open_eye) : SvgPicture.asset(Drawables.close_eye)),
    );
  }

  Widget confirmPasswordVisible() {
    return InkWell(
      onTap: (){
        controller.isConfirmPasswordVisible.value =  !controller.isConfirmPasswordVisible.value;
      },
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: (controller.isConfirmPasswordVisible.value == false) ? SvgPicture.asset(Drawables.open_eye) : SvgPicture.asset(Drawables.close_eye)),
    );
  }

}
