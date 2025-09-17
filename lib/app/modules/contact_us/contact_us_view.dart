import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/keyboard_types.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../core/widget/comman_textfield.dart';
import '../signup_1/model/CountryData.dart';
import '/app/core/base/base_view.dart';
import 'contact_us_controller.dart';

class ContactUsView extends BaseView<ContactUsController> {

  bool isAddtoCart = false;

  ContactUsView({super.key});

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
            Text(AppText.contact_us.toUpperCase(),
              style: appBarTitle,
              textAlign: TextAlign.center,
            )
          ],),),
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              color: Clr.white,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
          
                      SizedBox(
                        height: 20.h,
                      ),
                      CommanTextField(hint:"",label :AppText.your_name,keyboardType:KeyboardComman.NAME,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.fullNameController,isOnlyCharAllow: true,),
          
                       SizedBox(
                        height: 20.h,
                      ),
          
                      CommanTextField(hint:"",label : AppText.email,keyboardType:KeyboardComman.EMAIL,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.emailController,),
          
                       SizedBox(
                        height: 20.h,
                      ),
          
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
          
                         // prefix(context),
          
                         /* Flexible(
                            child:  CommanTextField(hint:"",label : AppText.mobile,keyboardType:KeyboardComman.PHONE,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.mobileController,),
                          ),*/

                          Flexible(
                            child:  CommanTextField(hint:"",label : AppText.mobile,keyboardType:KeyboardComman.PHONE,inputAction:KeyboardComman.NEXT,maxlines:1,controller: controller.mobileController,prefixIcon:  prefix(context),),
                          ),
                        ],
                      ),
          
                      SizedBox(
                        height: 20.h,
                      ),
          
                      TextField(
                        maxLines: 5,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        controller: controller.messageController,
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
                            hintText: AppText.write_message_here
                        ),
                      ),
          
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
          controller.contactUsService();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Clr.appColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),),
        ),
        child: Text(AppText.submit.toUpperCase(),style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
      ),
    );
  }
  
  
  TextStyle hintText() {
    return  TextStyle(
        fontSize: 14.sp, fontFamily: Fonts.PoppinsRegular, color: Clr.greyText);
  }

  Widget prefix(BuildContext context1){
    return   DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        dropdownStyleData: DropdownStyleData(
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

}
