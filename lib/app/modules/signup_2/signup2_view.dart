import 'dart:io';

import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:vteach_teacher/app/core/utils/api_services.dart';
import 'package:vteach_teacher/app/core/values/text_styles.dart';
import 'package:vteach_teacher/app/modules/signup_2/signup2_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/utils/keyboard_types.dart';
import '../../core/values/comman_text.dart';
import '../../core/widget/comman_textfield.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';


class Signup2View extends BaseView<SignUp2Controller> {

  bool isAddtoCart = false;

  Signup2View({super.key});

  List<Widget> widgetList = <Widget>[];

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Container(height: 40.h,
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
            Text(AppText.sign_up,
              style: appBarTitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 10.w,),
            Container(
              height: 5.h,
              width: 5.w,
              decoration: BoxDecoration(
                  color: Clr.greyColor,
                  shape: BoxShape.circle
              ),
            ),
            SizedBox(width: 10.w,),
            Text(AppText.step_2,
              style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: Fonts.PoppinsRegular,
                  color: Clr.yellowColor),
              textAlign: TextAlign.center,
            ),
          ],),),
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(
                        height: 20.h,
                      ),

                      Obx(() => ListView.builder(
                        itemCount: controller.textfieldControllers.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: CommanTextField(hint:"",label :AppText.document_title,keyboardType:KeyboardComman.NAME,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.textfieldControllers[index])),
                            SizedBox(
                              height: 20.h,
                            ),
                            InkWell(
                              onTap:(){
                                //controller.pickImage(index);
                                //controller.pickPdf(index);
                                chooseFileOption(context,index);
                          },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                               child: Stack(
                                 children: [

                                   DottedBorder(
                                     color: Clr.borderColor,
                                     strokeWidth: 1,
                                     radius : Radius.circular(20),
                                     borderType : BorderType.RRect,
                                     dashPattern: [4,2],
                                     child:Obx(() => Container(
                                       width: MediaQuery.of(context).size.width,
                                       height: MediaQuery.of(context).size.width * 0.6,
                                       child:  (controller.images[index] == null) ? Center(
                                           child: SvgPicture.asset(Drawables.placeholder1)) : Center(
                                           child: (controller.images[index]!.path.contains('pdf')) ? SvgPicture.asset(Drawables.pdf_document,height: 100,width: 100,) : ClipRRect(
                                               borderRadius: BorderRadius.circular(20),
                                               child: Image.file(File(controller.images[index]!.path),fit: BoxFit.fitWidth,))),
                                     ),),
                                   ),

                                   Obx(() => (controller.images[index] == null) ? SizedBox() : Positioned(
                                     right: 20,
                                     top :20,
                                     child: GestureDetector(
                                         onTap: (){
                                           // controller.textfieldControllers.removeAt(index);
                                           controller.images[index] = null;
                                         },
                                         child: SvgPicture.asset(Drawables.close)),),)
                                 ],
                               ),
                                                         ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),

                            Obx(() => (controller.textfieldControllers.length > 1) ?
                            GestureDetector(
                              onTap: (){
                                if(controller.images!.length == 1){
                                  CommonUtils.getIntance().toastMessage("At least one document must be available");
                                } else{
                                  controller.images.removeAt(index);
                                  controller.textfieldControllers.removeAt(index);
                                }
                              },
                              child:   Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(AppText.remove_lower,style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: Fonts.PoppinsRegular,
                                          color: Clr.redDark),)
                                    ],),
                                ),
                              ),
                            ) : SizedBox(),),

                            Obx(() => (controller.textfieldControllers.length > 1) ? SizedBox(height: 10.h,) : SizedBox(),),
                            (controller.textfieldControllers.length - 1 == index) ? SizedBox() : Container(
                              height: 10.h,
                              color: Clr.colorF5F5F5,
                            )
                          ],);
                        },),),


                      GestureDetector(
                        onTap: (){
                          controller.addTextField();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              SvgPicture.asset(Drawables.add),
                              Text(AppText.add_more,style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: Fonts.PoppinsRegular,
                                  color: Clr.color2020f2),)
                            ],),
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h,),

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
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Obx(() => (controller.isCheck.value) ? GestureDetector(
                  child:  Padding(
                    padding: EdgeInsets.only(top: 5),
                      child: SvgPicture.asset(Drawables.radio_on,height: 20.h,width: 20.h,)),
                  onTap: (){
                    controller.isCheck.value = false;
                  }) : GestureDetector(
                  child:  Padding(
                    padding: EdgeInsets.only(top: 5),
                      child: SvgPicture.asset(Drawables.radio_off,height: 20.h,width: 20.h,)),
                  onTap: (){
                    controller.isCheck.value = true;
                  }),),

              SizedBox(width: 10,),

              Flexible(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppText.i_agree_with,
                        style: PoppinsRegular14,
                        recognizer: TapGestureRecognizer()..onTap = () {
                          // Single tapped.
                        },
                      ),
                      TextSpan(
                          text: AppText.terms_and_conditions,
                          style: bluePoppinsRegular,
                          recognizer:  TapGestureRecognizer()..onTap = () {
                            Get.toNamed(Routes.WEB_VIEW,parameters:{"api" : term_and_condition} );
                          }
                      ),
                      TextSpan(
                        text: AppText.and,
                        style: PoppinsRegular14,
                        recognizer: LongPressGestureRecognizer()..onLongPress = () {
                          // Long Pressed.
                        },
                      ),
                      TextSpan(
                        text: AppText.privacy_policy,
                        style: bluePoppinsRegular,
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Get.toNamed(Routes.WEB_VIEW,parameters:{"api" : privacy_policy,} );
                        },
                      ),
                      TextSpan(
                        text: AppText.of_the_app,
                        style: PoppinsRegular14,
                        recognizer: TapGestureRecognizer()..onTap = () {
                          // Single tapped.
                        },
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
          SizedBox(height: 10.h,),
          Container(
            width: double.infinity,
            height: 45.h,
            child: ElevatedButton(
              onPressed: () {
                controller.signUpService();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Clr.appColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),),
              ),
              child: Text(AppText.sign_up.toUpperCase(),style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
            ),
          ),
          SizedBox(height: 10.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Text(
                  AppText.already_created_account,
                  style: blackPoppinsRegular14,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.SIGNIN);
                },
                child: Text(
                  AppText.sign_in_lower,
                  style:  TextStyle(
                    fontSize: 14.sp,
                    color: Clr.appColor,
                    fontFamily: Fonts.PoppinsRegular,
                    decoration: TextDecoration.underline,
                    decorationColor: Clr.appColor,
                    decorationThickness: 1.0,),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h,),
        ],
      ),
    );
  }

  Widget prefix(BuildContext context1){
    return Obx(() => SizedBox(width: 70.w,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
        onTap: (){
          showDialog(
            context: context1,
            builder: (context) => Theme(
                data: Theme.of(context).copyWith(primaryColor: Colors.pink),
                child: CountryPickerDialog(
                    titlePadding:  EdgeInsets.all(8.0),
                    isSearchable: false,
                    itemFilter:  (c) => ['IN', 'AU'].contains(c.isoCode),
                    onValuePicked: (value) {
                      controller.selectedDialogCountry.value = value;
                    },
                    itemBuilder: buildDialogItem)),
          );
        },
        title: buildDialogItem(controller.selectedDialogCountry.value),
      ),
    ));
  }

  Widget buildDialogItem(Country country){
    return Row(
      children: <Widget>[
         SizedBox(width: 5),
        Text("+${country.phoneCode}",style:  TextStyle(fontSize: 14.sp,color: Clr.black,fontFamily: Fonts.PoppinsMedium),),
      ],
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
          child: (controller.isPasswordVisible.value == false) ? SvgPicture.asset(Drawables.open_eye,height: 10,width: 10,) : SvgPicture.asset(Drawables.close_eye,height: 10,width: 10,)),
    );
  }

  Widget confirmPasswordVisible() {
    return InkWell(
      onTap: (){
        controller.isConfirmPasswordVisible.value =  !controller.isConfirmPasswordVisible.value;
      },
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: (controller.isConfirmPasswordVisible.value == false) ? SvgPicture.asset(Drawables.open_eye,height: 10,width: 10,) : SvgPicture.asset(Drawables.close_eye,height: 10,width: 10,)),
    );
  }

  /*void chooseFileOption(BuildContext context,int index){
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.width * 0.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  controller.pickImage(index);
                  Get.back();
                },
                child: Text('Select Image'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  controller.pickPdf(index);
                  Get.back();
                },
                child: Text('Select Pdf'),
              ),
            ],
          ),
        );
      },
    );
  }*/

  void chooseFileOption(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding:  EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          child: Wrap(  // Wrap allows dynamic height adjustment
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        controller.pickImage(index);
                        Get.back();
                      },
                      child: Text('Select Image'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        controller.pickPdf(index);
                        Get.back();
                      },
                      child: Text('Select Pdf'),
                    ),
                  ],),
              )
            ],
          ),
        );
      },
    );
  }



}
