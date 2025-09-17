import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:vteach_teacher/app/core/values/text_styles.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/utils/keyboard_types.dart';
import '../../core/values/comman_text.dart';
import '../../core/widget/comman_textfield.dart';
import '../SubjectWidgetUpdate.dart';
import '../signup_1/model/CountryData.dart';
import '../signup_1/model/GradesData.dart';
import '../signup_1/model/StateData.dart';
import '../signup_1/model/SubjectData.dart';
import '/app/core/base/base_view.dart';
import 'edit_profile_controller.dart';
import 'model/SubjectDataUpdate.dart';

class EditProfileView extends BaseView<EditProfileController> {

  bool isAddtoCart = false;

  EditProfileView({super.key});

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
          Text(AppText.edit_profile,
            style: appBarTitle,
            textAlign: TextAlign.center,
          )
        ],),),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    height: 20.h,
                  ),

                  Center(
                    child: GestureDetector(
                      onTap: (){
                        controller.pickImage();
                      },
                      child: Obx(()=>Container(
                        height: MediaQuery.of(context).size.width * 0.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Clr.colorD8D8D8),
                        color: Clr.viewBg
                        ),
                        child: (controller.selectedImage.value == null) ? (controller.myProfileData.value!.profileImage!.isEmpty) ? Center(child: SvgPicture.asset(Drawables.user_add,height: 30.h,width: 30.w,)) : ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.network(controller.myProfileData.value!.profileImage!,fit: BoxFit.cover,)) :
                        Image.file(File(controller.selectedImage.value!.path)),
                        )),
                    ),
                  ),
          
                  SizedBox(
                    height: 20.h,
                  ),

                  CommanTextField(hint:"",label :AppText.teacher_name,keyboardType:KeyboardComman.NAME,inputAction:KeyboardComman.DONE,maxlines:1,controller: controller.fullNameController,isOnlyCharAllow: true,),
          
                   SizedBox(
                    height: 10.h,
                  ),
          
                  CommanTextField(hint:"",label : AppText.email,keyboardType:KeyboardComman.EMAIL,inputAction:KeyboardComman.DONE,maxlines:1,controller: controller.emailController,isEnable: false,),
          
                   SizedBox(
                    height: 10.h,
                  ),
          
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
          
                     // prefix(context),
          
                      Flexible(
                        child:  CommanTextField(hint:"",label : AppText.mobile,keyboardType:KeyboardComman.PHONE,inputAction:KeyboardComman.DONE,maxlines:1,controller: controller.mobileController,isEnable: false,prefixIcon:  prefix(context),),
                      ),
                    ],
                  ),
          
                  SizedBox(
                    height: 15,
                  ),
          
/*                 selectGradeView(context),
          
                  SizedBox(
                    height: 15.h,
                  ),
          
                  GestureDetector(
                    onTap: (){
                      if(controller.selectedGrades.isEmpty){
                        CommonUtils.getIntance().toastMessage(AppText.please_select_grade_first);
                      }
                    },
                      child: selectSubjectView(context)),*/

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
                                        /*  if(controller.selectedGrades.isEmpty){
                                       CommonUtils.getIntance().toastMessage(AppText.please_select_grade_first);
                                     }*/
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
          
                  SizedBox(
                    height: 15.h,
                  ),
          
                 selectCountryView(context),
          
                  SizedBox(
                    height: 15.h,
                  ),

                  GestureDetector(
                    onTap: (){
                      if(controller.country.isEmpty) {
                        CommonUtils.getIntance().toastMessage(AppText.please_select_country_first);
                      }
                    },
                      child: selectStateView(context)),

                  SizedBox(
                    height: 15.h,
                  ),

                  GestureDetector(
                    onTap: (){
                      if(controller.state.isEmpty) {
                        CommonUtils.getIntance().toastMessage(AppText.please_select_state_first);
                      }
                    },
                      child: selectCityView(context)),

                  SizedBox(
                    height: 15.h,
                  ),

                  CommanTextField(hint:"",label : AppText.enter_experience,keyboardType:KeyboardComman.TEXT,inputAction:KeyboardComman.DONE,maxlines:1,controller: controller.experienceController,),
          
                  SizedBox(
                    height: 15.h,
                  ),
          
                  CommanTextField(hint:"",label : AppText.enter_education_background,keyboardType:KeyboardComman.TEXT,inputAction:KeyboardComman.DONE,maxlines:1,controller: controller.educationBackgroundController,),
          
                  SizedBox(
                    height: 15.h,
                  ),
          
                  CommanTextField(hint:"",label : AppText.enter_interest,keyboardType:KeyboardComman.TEXT,inputAction:KeyboardComman.DONE,maxlines:1,controller: controller.interestController,),
          
                  SizedBox(
                    height: 15.h,
                  ),
          
                  CommanTextField(hint:"",label : AppText.enter_spoken_languages,keyboardType:KeyboardComman.TEXT,inputAction:KeyboardComman.DONE,maxlines:1,controller: controller.spokenLanguageController,),
                  SizedBox(
                    height: 15.h,
                  ),

                  CommanTextField(hint:"",label : AppText.rate_per_hour,keyboardType:KeyboardComman.NUMBER,inputAction:KeyboardComman.DONE,maxlines:1,controller: controller.ratePerHoursController,),

                  SizedBox(
                    height: 5.h,
                  ),

                  Obx(() => Text(controller.commitionRate.toString(),style: blackPoppinsSemiBold12,),),

                  SizedBox(
                    height: 15.h,
                  ),

                  TextField(
                    maxLines: 5,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: controller.descriptionController,
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
          
                ],),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle hintText() {
    return  TextStyle(
        fontSize: 14.sp, fontFamily: Fonts.PoppinsRegular, color: Clr.colorBFBFBF);
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return   Container(
      width: double.infinity,
      height: 45.h,
      margin: EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: () {
         controller.updateProfile();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Clr.appColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),),
        ),
        child: Text(AppText.save_changes.toUpperCase(),style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
      ),
    );
  }

  openDialogSelectGrades(BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppText.select_grades_cap,style: blackPoppinsMediumm18,),
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
              SizedBox(height: 20.h,),
              Flexible(
                child: GridView.builder(
                  itemCount: controller.grades.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.7,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        controller.grades[index].isSelect!.value = !controller.grades[index].isSelect!.value;
                      },
                      child: Obx(() => Container(
                        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: (controller.grades[index].isSelect!.value == true) ? null : Border.all(color: Clr.color707070),
                          color: (controller.grades[index].isSelect!.value == true) ? Clr.blackColor : null,
                        ),
                        child: Center(
                          child: Text(controller.grades[index].grade.toString(),style:  TextStyle(
                              fontSize: 14.sp,
                              color: (controller.grades[index].isSelect!.value == true) ? Clr.white : Clr.blackColor,
                              fontFamily: Fonts.PoppinsRegular)),
                        ),
                      ),),
                    );
                  },),
              ),
              SizedBox(height: 20.h,),
              Container(
                width: double.infinity,
                height: 45.h,
                child: ElevatedButton(
                  onPressed: () {
                    controller.selectedGrades.clear();
                    for(int i=0; i<controller.grades.length; i++){
                      if(controller.grades[i].isSelect == true){
                        controller.selectedGrades.add(controller.grades[i]);
                      }
                    }
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
            width: MediaQuery.of(context1).size.width
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
        customButton: SizedBox(width: 60.w,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 8.0,
              ),
              Obx(() => Text(controller.countryCode.value,style: blackPoppinsRegular12,),),
              Icon(Icons.arrow_drop_down_outlined)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDialogItem(Country country){
    return Row(
      children: <Widget>[
        Container(
          child: CountryPickerUtils.getDefaultFlagImage(country),),
        const SizedBox(width: 3),
        Text("+${country.phoneCode}",style: const TextStyle(fontSize: 12,color: Clr.black,fontFamily: Fonts.PoppinsMedium),),
      ],
    );
  }

  void getSelectedSubjectListCheckingOriginal(List<SubjectDataUpdate> subjects,int mainIndex) {
    for (var subject in subjects) {
      print("Original--->"+subject.subject.toString());
      print("Original--->"+subject.isSelect.toString());
      if (subject.children.isNotEmpty) {
        getSelectedSubjectListCheckingOriginal(subject.children,mainIndex);
      }
    }
  }

  void getSelectedSubjectListCheckingUpdated(List<SubjectDataUpdate> subjects,int mainIndex) {
    for (var subject in subjects) {
      print("Updated--->"+subject.subject.toString());
      print("Updated--->"+subject.isSelect.value.toString());
      if (subject.children.isNotEmpty) {
        getSelectedSubjectListCheckingUpdated(subject.children,mainIndex);
      }
    }
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
                                    ,style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: Fonts.PoppinsMedium,
                      color: Clr.blackColor),overflow: TextOverflow.ellipsis,maxLines: 1,),
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
                  color: Clr.colorBFBFBF),) : Flexible(child: Text(controller.state.value
                ,style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: Fonts.PoppinsMedium,
                    color: Clr.blackColor),overflow: TextOverflow.ellipsis,maxLines: 1,)),
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
                    child: Text(controller.city.value
                                    ,style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: Fonts.PoppinsMedium,
                      color: Clr.blackColor),overflow: TextOverflow.ellipsis,maxLines: 1,),
                  ),
              SvgPicture.asset(Drawables.dropdown,height: 16.h,width: 16.w,)
            ],
          ),
        ),),

      ),
    ));
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
 /*         if(controller.gradesSubjectsList[index].selectedGrades.isNotEmpty){
            for(int i=0;i<controller.gradesSubjectsList[index].selectedGrades.length; i++){
              if(controller.gradesSubjectsList[index].selectedGrades[i].id == (value as GradesData).id){
                isExist = true;
              }
            }
          }*/

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
            if (controller.gradesSubjectsList[index].selectedGrades.contains(value as GradesData)) {}else {
              controller.gradesSubjectsList[index].selectedGrades.clear();
              controller.gradesSubjectsList[index].selectedGrades.add(value as GradesData);
              callSubjectListApi(index);
            }
          }

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

  Widget selectSubjectView(BuildContext context,int index){
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
        items: controller.gradesSubjectsList[index].subjects.value
            .map((item) => DropdownMenuItem<SubjectDataUpdate>(
          value: item,

          child: Text(
            item.subject.toString(),
            style: blackPoppinsMedium14,
          ),
        ))
            .toList(),
        value: controller.outletsSelectedName.toString().isNotEmpty ? controller.outletsSelectedName.toString() : null,
        onChanged: (value) {

          if(controller.gradesSubjectsList[index].selectedSubjects.length > 0){
            if(controller.gradesSubjectsList[index].selectedSubjects.contains(value as SubjectData)){
            }else{
              controller.gradesSubjectsList[index].selectedSubjects.add(value as SubjectDataUpdate);
            }
          }else{
            controller.gradesSubjectsList[index].selectedSubjects.add(value as SubjectDataUpdate);
          }
        },
        customButton: Obx(() => GestureDetector(
          onTap: (){
            if(controller.gradesSubjectsList[index].jsonValue.isNotEmpty) {
              List<dynamic> subjectList = jsonDecode(controller.gradesSubjectsList[index].jsonValue);
              RxList<SubjectDataUpdate> subjects = subjectList.map((json) => SubjectDataUpdate.fromJson(json)).toList().obs;
              controller.gradesSubjectsList[index].subjects.value = subjects;
              controller.gradesSubjectsList[index].tempSubjects.value = subjects;
              controller.gradesSubjectsList[index].duplicateSubjects.value = subjects;
            }

            if(controller.gradesSubjectsList[index].tempSelectedJson.isNotEmpty) {
              List<dynamic> tempSelectedSubjectList = jsonDecode(controller.gradesSubjectsList[index].tempSelectedJson);
              RxList<SubjectDataUpdate> tempSelected = tempSelectedSubjectList.map((json) => SubjectDataUpdate.fromJson(json)).toList().obs;
              controller.gradesSubjectsList[index].tempSelectedSubjects.value = tempSelected;
            }

             openDialogSelectSubjectNew(context,index);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: (controller.gradesSubjectsList[index].selectedSubjects.length > 0) ? 5.0 : 15.0,horizontal: (controller.gradesSubjectsList[index].selectedSubjects.length > 0) ? 5.0 : 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color:  Clr.borderColor, // Change border color on focus
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
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
                                        controller.gradesSubjectsList[index].jsonValue = jsonEncode(controller.gradesSubjectsList[index].subjects);
                                        controller..gradesSubjectsList[index].tempSelectedJson = jsonEncode(controller.gradesSubjectsList[index].tempSelectedSubjects);
                                        controller.gradesSubjectsList[index].selectedSubjects.refresh();
                                        controller.gradesSubjectsList[index].subjects.refresh();
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
                ),
                //Icon(Icons.add_circle,color: Clr.blackColor,)
              ],
            ),
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


  openDialogSelectSubjectNew(BuildContext context,int mainIndex){
    controller.isDataUpdated = false;
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
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppText.select_subjects,style: blackPoppinsMediumm18,),
                      InkWell(
                        onTap: (){
                          getSelectedSubjectListCheckingOriginal(controller.gradesSubjectsList[mainIndex].tempSubjects,mainIndex);
                          getSelectedSubjectListCheckingUpdated(controller.gradesSubjectsList[mainIndex].subjects,mainIndex);
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
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
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
                    return SubjectWidgetUpdate(subject: controller.gradesSubjectsList[mainIndex].subjects[index],index: index,isExpanded: (controller.gradesSubjectsList[mainIndex].selectedSubjects.length > 0) ? true : false,mainIndex: mainIndex,subjects: controller.gradesSubjectsList[mainIndex].subjects,);
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
                    controller.gradesSubjectsList[mainIndex].jsonValue = "";
                    controller.gradesSubjectsList[mainIndex].tempSelectedJson = "";
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

  void iterateSubjects(List<SubjectDataUpdate> subjects) {
    for (var subject in subjects) {
      if(subject.isSelect.value){
        subject.isSelect.value = false;
      }
      if (subject.children.isNotEmpty) {
        iterateSubjects(subject.children);
      }
    }
  }

  void getSelectedSubjectList(List<SubjectDataUpdate> subjects,int mainIndex) {
    for (var subject in subjects) {
      if(subject.isSelect.value){
        controller.gradesSubjectsList[mainIndex].selectedSubjects.add(subject);
      }
      if (subject.children.isNotEmpty) {
        getSelectedSubjectList(subject.children,mainIndex);
      }
    }
  }

  void updateSubjectListDialog(List<SubjectDataUpdate> subjects, int mainIndex, int id) {
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
  void updateSelectedSubjectListDialog(List<SubjectDataUpdate> subjects, int mainIndex, int id, int subIndex) {
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

  void setSelectedChildrenFalseDialog(List<SubjectDataUpdate> children, int mainIndex, int subIndex) {
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

  void setChildrenFalse(List<SubjectDataUpdate> children) {
    for (var child in children) {
      child.isSelect.value = false;
      if (child.children.isNotEmpty) {
        setChildrenFalse(child.children);
      }
    }
  }

  void updateSubjectList(List<SubjectDataUpdate> subjects, int mainIndex, int id) {
    for (var subject in subjects) {
      if (subject.id == id) {
        subject.isSelect.value = false;
        setChildrenFalse(subject.children);
      }
      if (subject.children.isNotEmpty) {
        updateSubjectList(subject.children, mainIndex, id);
      }
    }
  }

  void updateSelectedSubjectList(List<SubjectDataUpdate> subjects, int mainIndex, int id,int subIndex) {
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

  void setSelectedChildrenFalse(List<SubjectDataUpdate> children,int mainIndex,int subIndex) {
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
}
