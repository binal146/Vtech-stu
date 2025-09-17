import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:vteach_teacher/app/core/values/text_styles.dart';
import 'package:vteach_teacher/app/routes/app_pages.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/utils/keyboard_types.dart';
import '../../core/values/comman_text.dart';
import '../../core/widget/comman_textfield.dart';
import '/app/core/base/base_view.dart';
import 'login_controller.dart';

class LoginView extends BaseView<LoginController> {

  bool isAddtoCart = false;

  LoginView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Clr.white,
      toolbarHeight: 0,
    );
  }

  @override
  Widget body(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return true;
      },
      child: Container(
        color: Clr.white,
        width: MediaQuery.of(context).size.width,
        padding:  EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
          
              SizedBox(height: 40.h,),
          
              SvgPicture.asset(
                Drawables.app_icon,
                height: 100.h,
                width: 100.w,
                key: Key('app_icon'),
              ),
          
              SizedBox(height: 10.h,),
          
              Text(
               key: Key('sign_in_header'),
                AppText.sign_in,
                style:  TextStyle(
                    fontSize: 20.sp,
                    color: Clr.blackColor,
                    fontFamily: Fonts.PoppinsSemiBold),
              ),
          
              SizedBox(height: 10.h,),
          
              CommanTextField(
                hint: "",
                label: AppText.email,
                keyboardType: KeyboardComman.EMAIL,
                inputAction: KeyboardComman.NEXT,
                maxlines: 1,
                controller: controller.emailController,
              ),
               SizedBox(
                height: 20,
              ),
              Obx(
                    () => CommanTextField(
                  hint: "",
                  label: AppText.password,
                  keyboardType: KeyboardComman.PASSWORD,
                  inputAction: KeyboardComman.DONE,
                  maxlines: 1,
                  isPassword: controller.isPasswordVisible.value,
                  controller: controller.passwordController,
                  sufixIcon: passwordVisible(),
                ),
              ),
          
              SizedBox(
                height: 10.h,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.FORGOT_PASSWORD);
                    },
                    child: Text(
                      AppText.forgot_your_password,
                      style:  TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontFamily: Fonts.PoppinsRegular),
                    )),
              ),
               SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: () {
                    controller.signInService();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Clr.appColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                  child: Text(
                    key: Key('sign_in_button'),
                    AppText.sign_in,
                    style:  TextStyle(
                        fontSize: 16.sp,
                        color: Clr.white,
                        fontFamily: Fonts.PoppinsMedium),
                  ),
                ),
              ),
               SizedBox(
                height: 10.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {

    return Container(
      color: Clr.white,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Text(
              AppText.new_to_vteach,
              style: blackPoppinsRegular14,
            ),
          ),
           SizedBox(
            width: 5.w,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.SIGN_UP_1);
            },
            child: Text(
              AppText.create_an_account,
              style:  TextStyle(
                fontSize: 14.sp,
                color: Clr.appColor,
                fontFamily: Fonts.PoppinsRegular,
                decorationColor: Clr.appColor,
              ),
            ),
          ),
        ],
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
          child: (controller.isPasswordVisible.value == false) ? SvgPicture.asset(Drawables.open_eye,key: Key('open_eye'),) : SvgPicture.asset(Drawables.close_eye,key: Key('open_eye'),)),
    );
  }

}
