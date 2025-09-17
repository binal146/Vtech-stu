import 'dart:convert';

import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:vteach_teacher/app/core/values/text_styles.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/CountryData.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/GradesData.dart';
import 'package:vteach_teacher/app/modules/signup_1/model/StateData.dart';
import 'package:vteach_teacher/app/modules/signup_1/signup1_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/utils/keyboard_types.dart';
import '../../core/values/comman_text.dart';
import '../../core/widget/comman_textfield.dart';
import '../SubjectWidget.dart';
import '/app/core/base/base_view.dart';
import 'model/SubjectDataNew.dart';

class Signup1View extends BaseView<SignUp1Controller> {

  bool isAddtoCart = false;

  Signup1View({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
            Text(AppText.step_1,
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
              color: Clr.white,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    height: 10.h,
                  ),
          
                  CommanTextField(hint:"",label :AppText.teacher_name,keyboardType:KeyboardComman.NAME,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.teacherNameController,isOnlyCharAllow: true,),
          
                   SizedBox(
                    height: 10.h,
                  ),
          
                  CommanTextField(hint:"",label : AppText.email,keyboardType:KeyboardComman.EMAIL,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.emailController,),
          
                   SizedBox(
                    height: 10.h,
                  ),
          
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child:  CommanTextField(hint:"",label : AppText.mobile,keyboardType:KeyboardComman.PHONE,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.mobileController,prefixIcon:  prefix(context),),
                      ),
                    ],
                  ),
          

                   SizedBox(
                    height: 10.h,
                  ),

               Obx(() =>  ListView.builder(
                 itemCount: controller.textfieldControllers.length,
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                 itemBuilder: (context, index) {
                   return   Column(
                     children: [
                       DottedBorder(
                         color: Clr.borderColor,
                         strokeWidth: 1,
                         radius : Radius.circular(20),
                         borderType : BorderType.RRect,
                         dashPattern: [4,2],
                         child: Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                             color: Clr.colorFAFAFA,
                           ),
                           padding: EdgeInsets.all(10),
                           child: Column(
                             children: [
                               selectGradeView(context,index),

                               SizedBox(
                                 height: 15.h,
                               ),

                               GestureDetector(
                                   onTap: (){

                                   },
                                   child: selectSubjectView(context,index)),
                               SizedBox(
                                 height: 5.h,
                               ),
                               Obx(() => (controller.textfieldControllers.length > 1) ?
                               GestureDetector(
                                 onTap: (){
                                   controller.textfieldControllers.removeAt(index);
                                   controller.gradesSubjectsList.removeAt(index);

                                 },
                                 child: Align(
                                   alignment: Alignment.centerRight,
                                   child: Text(AppText.remove_lower,style: TextStyle(
                                       fontSize: 14.sp,
                                       fontFamily: Fonts.PoppinsRegular,
                                       color: Clr.redDark),),
                                 ),
                               ) : SizedBox(),)
                             ],
                           ),
                         ),

                       ),
                       Obx(() => (controller.textfieldControllers.length - 1 == index) ? Padding(
                         padding : EdgeInsets.symmetric(vertical: 10),
                         child: GestureDetector(
                           onTap: (){
                             controller.addTextField();
                           },
                           child: Align(
                             alignment: Alignment.centerRight,
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 SvgPicture.asset(Drawables.add),
                                 Text(AppText.add_grade,style: TextStyle(
                                     fontSize: 14.sp,
                                     fontFamily: Fonts.PoppinsRegular,
                                     color: Clr.color2020f2),)
                               ],),
                           ),
                         ),
                       ) : SizedBox(height: 15,),),
                     ],
                   );
                 },),),


                  selectCountryView(context),



                  SizedBox(
                   height: 15.h,
                  ),

                  GestureDetector(
                    onTap: (){
                      if(controller.country.isEmpty){
                        CommonUtils.getIntance().toastMessage(AppText.please_select_country_first);
                      }
                    },
                      child: selectStateView(context)),

                  SizedBox(
                    height: 15.h,
                  ),

                  GestureDetector(
                    onTap: (){
                      if(controller.city.isEmpty){
                        CommonUtils.getIntance().toastMessage(AppText.please_select_state_first);
                      }
                    },
                      child: selectCityView(context)),

                  SizedBox(
                    height: 15.h,
                  ),

                  CommanTextField(hint:"",label : AppText.enter_experience,keyboardType:KeyboardComman.TEXT,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.experienceController,),

                  SizedBox(
                    height: 15.h,
                  ),

                  CommanTextField(hint:"",label : AppText.enter_education_background,keyboardType:KeyboardComman.TEXT,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.educationBackgroundController,),

                  SizedBox(
                    height: 15.h,
                  ),

                  CommanTextField(hint:"",label : AppText.enter_interest,keyboardType:KeyboardComman.TEXT,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.interestController,),

                  SizedBox(
                    height: 15.h,
                  ),

                  CommanTextField(hint:"",label : AppText.enter_spoken_languages,keyboardType:KeyboardComman.TEXT,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.spokenLangaugesController,),
                  SizedBox(
                    height: 15.h,
                  ),

                  TextField(
                    maxLines: 5,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: controller.descriptionController,
                    textInputAction: TextInputAction.none,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide(
                            color:  Clr.borderColor, // Change border color on focus
                            width: 0.5,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide(
                            color:  Clr.borderColor, // Change border color on focus
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide: BorderSide(
                            color:  Clr.borderColor, // Change border color on focus
                            width: 0.5,
                          ),
                        ),
                        hintStyle: hintText(),
                        hintText: AppText.description
                    ),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),

                  CommanTextField(hint:"",label : AppText.rate_per_hour,keyboardType:KeyboardComman.NUMBER,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.ratePerHoursController,),

                  SizedBox(
                    height: 5.h,
                  ),

                  Obx(() => Text(controller.commitionRate.value.toString(),style: blackPoppinsSemiBold12,),),

                  SizedBox(
                    height: 15.h,
                  ),

                  Obx(() => CommanTextField(hint:"",label : AppText.password,keyboardType:KeyboardComman.PASSWORD,inputAction:KeyboardComman.NEXT,maxlines:1,isPassword:controller.isPasswordVisible.value,controller: controller.passwordController,sufixIcon: passwordVisible(),),),

                  SizedBox(
                    height: 15.h,
                  ),

                  Obx(() => CommanTextField(hint:"",label : AppText.confirm_password,keyboardType:KeyboardComman.PASSWORD,inputAction:KeyboardComman.DONE,maxlines:1,isPassword:controller.isConfirmPasswordVisible.value,controller: controller.confirmPasswordController,sufixIcon: confirmPasswordVisible(),),),

                   SizedBox(
                    height: 60.h,
                  ),

                ],),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return   Container(
      width: double.infinity,
      height: 45.h,
      color: Clr.white,
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: ElevatedButton(
        onPressed: () {
          //Get.toNamed(Routes.SIGN_UP_2);
         // controller.nextScreen();
          controller.signUpService();
         // Get.toNamed(Routes.SIGN_UP_2);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Clr.appColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),),
        ),
        child: Text(AppText.next.toUpperCase(),style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
      ),
    );
  }

  TextStyle hintText() {
    return  TextStyle(
        fontSize: 14.sp, fontFamily: Fonts.PoppinsRegular, color: Clr.colorBFBFBF);
  }

  Widget prefixOld(BuildContext context1){
    return Obx(() => SizedBox(width: 60.w,
      child: ListTile(
        contentPadding:  EdgeInsets.only(left: 0.0, right: 0.0),
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
        title: buildViewItem(controller.selectedDialogCountry.value),
      ),
    ));
  }

  Widget prefix11(BuildContext context1){

    return SizedBox(width: 60.w,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8.0,
          ),
          Text("+91",style: blackPoppinsRegular12,),
          Icon(Icons.arrow_drop_down_outlined)
        ],
      ),
    );

  }

  Widget prefix(BuildContext context1){
    return   DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        dropdownStyleData: DropdownStyleData(
            maxHeight: MediaQuery.of(context1).size.height * 0.8,
          decoration: BoxDecoration(
            color: Clr.white, // Set your desired background color here
            borderRadius: BorderRadius.circular(10), // Customize the border radius if needed
          ),
            width: MediaQuery.of(context1).size.width * 0.9
        ),
        items: controller.countryList.value
            .map((item) => DropdownMenuItem<CountryData>(
          value: item,

          child: Text(
            item.phonecode.toString()+"  "+item.name.toString(),
            style: blackPoppinsMedium14,
          ),
        ))
            .toList(),
        value: controller.outletsSelectedName.toString().isNotEmpty ? controller.outletsSelectedName.toString() : null,
        onChanged: (value) {
          controller.countryCode.value = (value as CountryData).phonecode.toString();
          controller.isoCode.value = (value as CountryData).iso_code.toString();
        },
        customButton: SizedBox(width: 70.w,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 8.0,
              ),
              Obx(() => Text(controller.countryCode.value,
                style: blackPoppinsRegular12,),),
              Icon(Icons.arrow_drop_down_outlined)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildViewItem(Country country){
    return Row(
      children: <Widget>[
         SizedBox(width: 5),
        Text("+${country.phoneCode} ${country.name}",style:  TextStyle(fontSize: 14.sp,color: Clr.black,fontFamily: Fonts.PoppinsMedium),),
        Icon(Icons.arrow_drop_down_outlined,size: 24,),
      ],
    );
  }

  Widget buildDialogItem(Country country){
    return Row(
      children: <Widget>[
        SizedBox(width: 5),
        Text("+${country.phoneCode} ${country.name}",style:  TextStyle(fontSize: 14.sp,color: Clr.black,fontFamily: Fonts.PoppinsMedium),),
      ],
    );
  }

  Widget buildDialogItemCountry(Country country){
    return Row(
      children: <Widget>[
        SizedBox(width: 5),
        Flexible(child: Text(country.name.toString(),style:  TextStyle(fontSize: 14.sp,color: Clr.black,fontFamily: Fonts.PoppinsMedium),)),
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
          child: (controller.isPasswordVisible.value == false) ? SvgPicture.asset(Drawables.open_eye,) : SvgPicture.asset(Drawables.close_eye)),
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

  Widget selectGradeView(BuildContext context,int index){
    return Obx(()=>DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        dropdownStyleData: DropdownStyleData(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Clr.white, // Set your desired background color here
            borderRadius: BorderRadius.circular(10), // Customize the border radius if needed
          ),
        ),
        items: controller.grades.value
            .map((item) => DropdownMenuItem<GradesData>(
          value: item,

          child: Text(
            item.grade.toString(),
            style: blackPoppinsMedium14,
          ),
        ))
            .toList(),
        value: controller.outletsSelectedName.toString().isNotEmpty ? controller.outletsSelectedName.toString() : null,
        onChanged: (value) {
          bool isExist = false;
          for(int i=0;i<controller.gradesSubjectsList.length; i++){

            if(controller.gradesSubjectsList[i].selectedGrades.isNotEmpty) {
              if (controller.gradesSubjectsList[i].selectedGrades[0].id == (value as GradesData).id) {
                isExist = true;
              }
            }
          }

          if(isExist){
            CommonUtils.getIntance().toastMessage(AppText.grade_already_added);
          }else {
            if (controller.gradesSubjectsList[index].selectedGrades.contains(value as GradesData)) {

            }else {
              controller.gradesSubjectsList[index].selectedGrades.clear();
              controller.gradesSubjectsList[index].selectedGrades.add(value as GradesData);
              callSubjectListApi(index);
            }
          }

      /*    if(controller.gradesSubjectsList[index].selectedGrades.contains(value as GradesData)){
          }else{
            controller.gradesSubjectsList[index].selectedGrades.clear();
            controller.gradesSubjectsList[index].selectedGrades.add(value as GradesData);
            callSubjectListApi(index);
          }*/

        },
        customButton: Obx(() => Container(
          padding: EdgeInsets.symmetric(vertical: (controller.gradesSubjectsList[index].selectedGrades.length > 0) ? 5.0 : 15.0,horizontal: (controller.gradesSubjectsList[index].selectedGrades.length > 0) ? 5.0 : 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color:  Clr.borderColor, // Change border color on focus
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              (controller.gradesSubjectsList[index].selectedGrades.length > 0) ? SizedBox() : Expanded(
                child: Text(AppText.select_grades,style:
                TextStyle(
                    fontSize: 14.sp,
                    fontFamily: Fonts.PoppinsRegular,
                    color: Clr.colorBFBFBF),),
              ),
              (controller.gradesSubjectsList[index].selectedGrades.length > 0) ? Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Clr.blackColor,
                ),
                child: Row(
                  children: [
                    Text(controller.gradesSubjectsList[index].selectedGrades[0].grade.toString(),style:  TextStyle(
                        fontSize: 12.sp,
                        color: Clr.white,
                        fontFamily: Fonts.PoppinsRegular)),
                  ],
                ),
              ) : SizedBox(),
            ],
          ),
        ),),

      ),
    ));
  }

  void callSubjectListApi(int index) {

    List<String> filteredList = [];
    for(int i = 0; i<controller.gradesSubjectsList[index].selectedGrades.length; i++){
      filteredList.add(controller.gradesSubjectsList[index].selectedGrades[i].id.toString());
    }
    controller.gradesSubjectsList[index].jsonValue = '';
    controller.gradesSubjectsList[index].tempSelectedJson = '';
    String grades = filteredList.join(',');

    controller.callSubjectListService(grades,index);
  }



  Widget selectSubjectView(BuildContext context,int index){
    return GestureDetector(
      onTap: (){
        if(controller.gradesSubjectsList[index].jsonValue.isNotEmpty) {
          List<dynamic> subjectList = jsonDecode(controller.gradesSubjectsList[index].jsonValue);
          RxList<SubjectDataNew> subjects = subjectList.map((json) => SubjectDataNew.fromJson(json)).toList().obs;
          controller.gradesSubjectsList[index].subjects.value = subjects;
          controller.gradesSubjectsList[index].tempSubjects.value = subjects;
          controller.gradesSubjectsList[index].duplicateSubjects.value = subjects;
        }

        if(controller.gradesSubjectsList[index].tempSelectedJson.isNotEmpty) {
          List<dynamic> tempSelectedSubjectsList = jsonDecode(controller.gradesSubjectsList[index].tempSelectedJson);
          RxList<SubjectDataNew> tempSelectedSubjects = tempSelectedSubjectsList.map((json) => SubjectDataNew.fromJson(json)).toList().obs;
          controller.gradesSubjectsList[index].tempSelectedSubjects.value = tempSelectedSubjects;
        }
        openDialogSelectSubjectNew(context,index);
      },
      child: Obx(() => Container(
        padding: EdgeInsets.symmetric(vertical: (controller.gradesSubjectsList[index].selectedSubjects.length > 0) ? 5.0 : 15.0,horizontal: (controller.gradesSubjectsList[index].selectedSubjects.length > 0) ? 5.0 : 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color:  Clr.borderColor, // Change border color on focus
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            (controller.gradesSubjectsList[index].selectedSubjects.length > 0) ? SizedBox() : Text(AppText.select_subjects,style:
            TextStyle(
                fontSize: 14.sp,
                fontFamily: Fonts.PoppinsRegular,
                color: Clr.colorBFBFBF),),

            (controller.gradesSubjectsList[index].selectedSubjects.length > 0) ? Flexible(
              child: Wrap(
                    spacing: 8.0, // Adjust spacing between chips as needed
                    runSpacing: 8.0, // Adjust run spacing as needed
                    children:
                    List.generate(controller.gradesSubjectsList[index].selectedSubjects.length, (index1) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Clr.blackColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(controller.gradesSubjectsList[index].selectedSubjects[index1].subject.toString(),style:  TextStyle(
                                fontSize: 12.sp,
                                color: Clr.white,
                                fontFamily: Fonts.PoppinsRegular)),
                            SizedBox(width: 3.w,),
                            GestureDetector(
                                onTap: (){
                                  updateSubjectList(controller.gradesSubjectsList[index].subjects,index,controller.gradesSubjectsList[index].selectedSubjects.value[index1].id);
                                  updateSelectedSubjectList(controller.gradesSubjectsList[index].subjects,index,controller.gradesSubjectsList[index].selectedSubjects.value[index1].id,index1);
                                  controller.gradesSubjectsList[index].selectedSubjects.refresh();
                                  controller.gradesSubjectsList[index].subjects.refresh();
                                  controller.gradesSubjectsList[index].jsonValue = jsonEncode(controller.gradesSubjectsList[index].subjects);
                                  controller.gradesSubjectsList[index].tempSelectedJson = jsonEncode(controller.gradesSubjectsList[index].tempSelectedSubjects);
                                },
                                child: SvgPicture.asset(Drawables.close,height: 16.h,width: 16.w,)),
                          ],
                        ),
                      );
                    },),
                  ),
            ) : SizedBox(),


          ],
        ),
      ),),
    );
  }

  Widget selectCountryView(BuildContext context){
    return Obx(()=>DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        dropdownStyleData: DropdownStyleData(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Clr.white, // Set your desired background color here
            borderRadius: BorderRadius.circular(10), // Customize the border radius if needed
          ),
        ),
        items: controller.countryList.value
            .map((item) => DropdownMenuItem<CountryData>(
          value: item,

          child: Text(
            item.name.toString(),
            style: blackPoppinsMedium14,
          ),
        ))
            .toList(),
        value: controller.outletsSelectedName.toString().isNotEmpty ? controller.outletsSelectedName.toString() : null,
        onChanged: (value) {
          controller.country.value = (value as CountryData).name.toString();
          controller.countryId = (value as CountryData).id.toString();
          controller.callStateListService((value as CountryData).id.toString());
        },
        customButton: Obx(() => Container(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color:  Clr.borderColor, // Change border color on focus
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (controller.country.value.isEmpty) ? Text(AppText.select_country,style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: Fonts.PoppinsRegular,
                  color: Clr.colorBFBFBF),) : Flexible(
                    child: Text(controller.country.value
                                    ,overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: Fonts.PoppinsMedium,
                      color: Clr.blackColor),),
                  ),
              SvgPicture.asset(Drawables.dropdown,height: 16.h,width: 16.w,)
            ],
          ),
        ),),

      ),
    ));
  }

  Widget selectStateView(BuildContext context){
    return Obx(()=>DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        dropdownStyleData: DropdownStyleData(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Clr.white, // Set your desired background color here
            borderRadius: BorderRadius.circular(10), // Customize the border radius if needed
          ),
        ),
        items: controller.stateList.value
            .map((item) => DropdownMenuItem<StateData>(
          value: item,

          child: Text(
            item.name.toString(),
            style: blackPoppinsMedium14,
          ),
        ))
            .toList(),
        value: controller.outletsSelectedName.toString().isNotEmpty ? controller.outletsSelectedName.toString() : null,
        onChanged: (value) {
          controller.state.value = (value as StateData).name.toString();
          controller.stateId = (value as StateData).id.toString();
          controller.callCityListService((value as StateData).id.toString());
        },
        customButton: Obx(() => Container(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color:  Clr.borderColor, // Change border color on focus
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (controller.state.value.isEmpty) ? Text(AppText.select_state,style: TextStyle(
              fontSize: 14.sp,
              fontFamily: Fonts.PoppinsRegular,
              color: Clr.colorBFBFBF),) : Flexible(
                child: Text(controller.state.value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: Fonts.PoppinsMedium,
                    color: Clr.blackColor),),
              ),
              SvgPicture.asset(Drawables.dropdown,height: 16.h,width: 16.w,)
            ],
          ),
        ),),

      ),
    ));
  }

  Widget selectCityView(BuildContext context){
    return Obx(()=>DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        dropdownStyleData: DropdownStyleData(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Clr.white, // Set your desired background color here
            borderRadius: BorderRadius.circular(10), // Customize the border radius if needed
          ),
        ),
        items: controller.cityList.value
            .map((item) => DropdownMenuItem<StateData>(
          value: item,

          child: Text(
            item.name.toString(),
            style: blackPoppinsMedium14,
          ),
        ))
            .toList(),
        value: controller.outletsSelectedName.toString().isNotEmpty ? controller.outletsSelectedName.toString() : null,
        onChanged: (value) {
          controller.city.value = (value as StateData).name.toString();
          controller.cityId =  (value as StateData).id.toString();
        },
        customButton: Obx(() => Container(
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal:20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color:  Clr.borderColor, // Change border color on focus
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (controller.city.value.isEmpty) ? Text(AppText.select_city,style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: Fonts.PoppinsRegular,
                  color: Clr.colorBFBFBF),) : Flexible(
                    child: Text(controller.city.value,
                      overflow:TextOverflow.ellipsis,
                      style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: Fonts.PoppinsMedium,
                      color: Clr.blackColor),),
                  ),
              SvgPicture.asset(Drawables.dropdown,height: 16.h,width: 16.w,)
            ],
          ),
        ),),

      ),
    ));
  }

  Widget selectCountry(BuildContext context1){
    return Obx(() => ListTile(
      contentPadding:  EdgeInsets.only(left: 0.0, right: 0.0),
      onTap: (){
        showDialog(
          context: context1,
          builder: (context) => Theme(
              data: Theme.of(context).copyWith(primaryColor: Colors.pink),
              child: CountryPickerDialog(
                  titlePadding:  EdgeInsets.all(8.0),
                  title: Text(AppText.select_country,style: TextStyle(fontSize: 20.sp,color: Clr.blackColor,fontFamily: Fonts.PoppinsMedium),),
                  isSearchable: false,
                  onValuePicked: (value) {
                    controller.selectedCountry.value = value;
                    controller.country.value = value.name.toString();
                  },
                  itemBuilder: buildDialogItemCountry)),
        );
      },
      title: buildCountryDialogItem(controller.selectedDialogCountry.value),
    ));
  }

  Widget buildCountryDialogItem(Country country){
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color:  Clr.borderColor, // Change border color on focus
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Obx(() => (controller.country.value.isEmpty) ? Text(AppText.select_country,style:
            TextStyle(
                fontSize: 14.sp,
                fontFamily: Fonts.PoppinsRegular,
                color: Clr.colorBFBFBF),) : Text(controller.selectedCountry.value.name.toString(),style:
            TextStyle(
                fontSize: 14.sp,
                fontFamily: Fonts.PoppinsMedium,
                color: Clr.blackColor),),),
          ),
          SvgPicture.asset(Drawables.dropdown,height: 16.h,width: 16.w,)
        ],
      ),
    );
  }


  openDialogSelectSubjectNew(BuildContext context,int mainIndex){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Clr.white,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppText.select_subjects,style: blackPoppinsMediumm18,),
                      InkWell(
                        onTap: (){
                          controller.searchContoller.text = '';
                          Navigator.pop(context);
                        },
                        child: Text(AppText.close,style: TextStyle(
                            fontSize: 16.sp,
                            color: Clr.borderColor,
                            fontFamily: Fonts.PoppinsRegular),),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),

                    Obx(() => (controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.length > 0) ? Wrap(
                      spacing: 8.0, // Adjust spacing between chips as needed
                      runSpacing: 8.0, // Adjust run spacing as needed
                      children:
                      List.generate(controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.length, (index1) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Clr.blackColor,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(controller.gradesSubjectsList[mainIndex].tempSelectedSubjects[index1].subject.toString(),style:  TextStyle(
                                  fontSize: 12.sp,
                                  color: Clr.white,
                                  fontFamily: Fonts.PoppinsRegular)),
                              SizedBox(width: 3.w,),
                              GestureDetector(
                                  onTap: (){
                                    updateSubjectListDialog(controller.gradesSubjectsList[mainIndex].subjects,mainIndex,controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.value[index1].id);
                                    updateSelectedSubjectListDialog(controller.gradesSubjectsList[mainIndex].subjects,mainIndex,controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.value[index1].id,index1);
                                    controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.refresh();
                                    controller.gradesSubjectsList[mainIndex].subjects.refresh();
                                  },
                                  child: SvgPicture.asset(Drawables.close,height: 16.h,width: 16.w,)),
                            ],
                          ),
                        );
                      },),
                    ) : SizedBox(),),

                    SizedBox(height: 10.h,),
                  Container(
                    height: 40.h,
                    child: TextField(
                      cursorColor: Clr.addCart,
                      style: TextStyle(color: Colors.black),
                      controller: controller.searchContoller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: SvgPicture.asset(Drawables.search),
                        prefixIconConstraints: BoxConstraints(
                          minHeight: 14.h,
                          minWidth: 14.w,
                        ),
                        prefixIconColor: MaterialStateColor.resolveWith((states) =>
                        states.contains(MaterialState.focused)
                            ? Clr.grey_bg
                            : Clr.grey_bg),
                        suffixIconColor: MaterialStateColor.resolveWith((states) =>
                        states.contains(MaterialState.focused)
                            ? Colors.black
                            : Colors.black),
                        focusColor: Clr.appColor,
                        hintStyle: TextStyle(
                            fontSize: 14.sp, fontFamily: Fonts.PoppinsRegular, color:Clr.greyColor),
                        hintText: AppText.search_subject,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0),
                          borderSide: BorderSide(
                            color:  Clr.borderColor, // Change border color on focus
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0),
                          borderSide: BorderSide(
                            color:  Clr.borderColor, // Change border color on focus
                            width: 0.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0),
                          borderSide: BorderSide(
                            color:  Clr.borderColor, // Change border color on focus
                            width: 0.5,
                          ),
                        ),

                      ),
                      onChanged: (value){
                        controller.filterSearchResults(value,mainIndex);
                      },

                    ),
                  ),
                  SizedBox(height: 10.h,),
                  GestureDetector(
                    onTap: (){
                      iterateSubjects(controller.gradesSubjectsList[mainIndex].subjects);
                      controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.clear();
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(AppText.clear_all,style: TextStyle(
                          fontSize: 16.sp,
                          color: Clr.borderColor,
                          fontFamily: Fonts.PoppinsRegular),),
                    ),
                  ),
                ],),
              ),
              Divider(color: Clr.greyColor,),
              Flexible(
                child: Obx(() => ListView.builder(
                  itemCount: controller.gradesSubjectsList[mainIndex].subjects.length,
                  itemBuilder: (context, index) {
                    return SubjectWidget(subject: controller.gradesSubjectsList[mainIndex].subjects[index],index: index,isExpanded: (controller.gradesSubjectsList[mainIndex].selectedSubjects.length > 0) ? true : false,mainIndex: mainIndex,subjects:controller.gradesSubjectsList[mainIndex].subjects);
                  },
                ),),
              ),
              SizedBox(height: 20.h,),
              Container(
                width: double.infinity,
                height: 45.h,
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    controller.searchContoller.text = '';
                    controller.gradesSubjectsList[mainIndex].selectedSubjects.clear();
                    controller.gradesSubjectsList[mainIndex].jsonValue = jsonEncode(controller.gradesSubjectsList[mainIndex].tempSubjects);
                    controller.gradesSubjectsList[mainIndex].tempSelectedJson = jsonEncode(controller.gradesSubjectsList[mainIndex].tempSelectedSubjects);
                    getSelectedSubjectList(controller.gradesSubjectsList[mainIndex].tempSubjects,mainIndex);
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Clr.appColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),),
                  ),
                  child: Text(AppText.done,style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
                ),
              )
            ],
          ),
        );
      },
    );

  }

  void iterateSubjects(List<SubjectDataNew> subjects) {
    for (var subject in subjects) {
      if(subject.isSelect.value){
        subject.isSelect.value = false;
      }
      if (subject.children.isNotEmpty) {
        iterateSubjects(subject.children);
      }
    }
  }

  void getSelectedSubjectList(List<SubjectDataNew> subjects,int mainIndex) {
    //controller.gradesSubjectsList[mainIndex].selectedSubjects.clear();
    for (var subject in subjects) {
      if(subject.isSelect.value){
        controller.gradesSubjectsList[mainIndex].selectedSubjects.add(subject);
      }
      if (subject.children.isNotEmpty) {
        getSelectedSubjectList(subject.children,mainIndex);
      }
    }
  }

  void updateSubjectList(List<SubjectDataNew> subjects, int mainIndex, int id) {
    for (var subject in subjects) {
      if (subject.id == id) {
        subject.isSelect.value = false;
        // Set all children isSelect.value to false
        setChildrenFalse(subject.children);
      }
      if (subject.children.isNotEmpty) {
        updateSubjectList(subject.children, mainIndex, id);
      }
    }
  }

  void setChildrenFalse(List<SubjectDataNew> children) {
    for (var child in children) {
      child.isSelect.value = false;
      if (child.children.isNotEmpty) {
        setChildrenFalse(child.children);
      }
    }
  }

  void updateSelectedSubjectList(List<SubjectDataNew> subjects, int mainIndex, int id,int subIndex) {
    for (var subject in subjects) {
      if (subject.id == id) {
        subject.isSelect.value = false;
        if(subIndex < controller.gradesSubjectsList[mainIndex].selectedSubjects.length) {
          controller.gradesSubjectsList[mainIndex].selectedSubjects.value.removeAt(subIndex);
        }
        if(subIndex < controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.length) {
          controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.value.removeAt(subIndex);
        }
        setSelectedChildrenFalse(subject.children,mainIndex,subIndex);
      }
      if (subject.children.isNotEmpty) {
        updateSelectedSubjectList(subject.children, mainIndex, id,subIndex);
      }
    }
  }


  void setSelectedChildrenFalse(List<SubjectDataNew> children,int mainIndex,int subIndex) {
    for (var child in children) {
      child.isSelect.value = false;
      if(subIndex < controller.gradesSubjectsList[mainIndex].selectedSubjects.length) {
        controller.gradesSubjectsList[mainIndex].selectedSubjects.value.removeAt(subIndex);
      }
      if(subIndex < controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.length) {
        controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.value.removeAt(subIndex);
      }
      if (child.children.isNotEmpty) {
        setSelectedChildrenFalse(child.children,mainIndex,subIndex);
      }
    }
  }

  void setSelectedChildrenFalseDialogOld(List<SubjectDataNew> children,int mainIndex,int subIndex) {
    for (var child in children) {
      child.isSelect.value = false;
      controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.value.removeAt(subIndex);
      if (child.children.isNotEmpty) {
        setSelectedChildrenFalseDialog(child.children,mainIndex,subIndex);
      }
    }
  }

  void updateSubjectListDialog(List<SubjectDataNew> subjects, int mainIndex, int id) {
    for (var subject in subjects) {
      if (subject.id == id) {
        subject.isSelect.value = false;
        setChildrenFalse(subject.children);
      }
      if (subject.children.isNotEmpty) {
        updateSubjectListDialog(subject.children, mainIndex, id);
      }
    }
  }


  // bottomsheet dialog code
  void updateSelectedSubjectListDialog(List<SubjectDataNew> subjects, int mainIndex, int id, int subIndex) {
    for (var subject in subjects) {
      if (subject.id == id) {
        subject.isSelect.value = false;
        if (subIndex < controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.value.length) {
          controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.value.removeAt(subIndex);
        }
        setSelectedChildrenFalseDialog(subject.children, mainIndex, subIndex);
      }
      if (subject.children.isNotEmpty) {
        updateSelectedSubjectListDialog(subject.children, mainIndex, id, subIndex);
      }
    }
  }

  void setSelectedChildrenFalseDialog(List<SubjectDataNew> children, int mainIndex, int subIndex) {
    for (var child in children) {
      child.isSelect.value = false;
      if (subIndex < controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.value.length) {
        controller.gradesSubjectsList[mainIndex].tempSelectedSubjects.value.removeAt(subIndex);
      }
      if (child.children.isNotEmpty) {
        setSelectedChildrenFalseDialog(child.children, mainIndex, subIndex);
      }
    }
  }

}
