import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/confirm_appointment/confirm_appointment_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';


class ConfirmAppointmentView extends BaseView<ConfirmAppointmentController> {

  ConfirmAppointmentView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Column(
      children: [
        Container(height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 10),
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
            Text(AppText.confirm_appointment,
              style: appBarTitle,
              textAlign: TextAlign.center,
            )
          ],),),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding:  EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          
                  SizedBox(height: 10.h,),
          
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Clr.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Clr.grey_border)
                    ),
          
                    child: Row(children: [
          
                      SizedBox(
                          height: 100.sp,
                          width: 100.sp,
                          //square box; equal height and width so that it won't look like oval
                          child: Image.asset(Drawables.dummy3)),
          
                      SizedBox(width: 5.w,),
          
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
          
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(Drawables.star),
                                        SizedBox(width: 3.w,),
                                        Text('4.0 (245k)',style: greyPoppinsRegular12,)
                                      ],
                                    ),
                                    SizedBox(height: 5.h,),
                                    Text('John Smith',style: blackPoppinsMedium18,)
                                  ],
                                ),
                                Text(' \$24/hr',style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Clr.yellowColor,
                                    fontFamily: Fonts.PoppinsMedium),)
                              ],),
                            SizedBox(height: 5.h,),
                            Text('Exp: 12 years',style: blackPoppinsLight12,),
                            SizedBox(height: 5.h,),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Clr.green200,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                                child: Text('Biology',style: blackPoppinsMedium12 ,))
                          ],
                        ),
                      )
          
                    ],),
                  ),
          
                  SizedBox(height: 10.h,),
          
                  Container(
                    padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
            color: Clr.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey[300]!)
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
          
                    Text(AppText.selected_period,style: greyPoppinsLight14,),
          
                    InkWell(
                      onTap: (){
                        Get.toNamed(Routes.AVAILABILITY,arguments: "0");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          color: Clr.light_blue
                        ),
                        padding: EdgeInsets.all(7),
                        child: Text(AppText.edit,style: TextStyle(
                            fontSize: 12.sp,
                            color: Clr.appColor ,
                            fontFamily: Fonts.PoppinsMedium),),),
                    )
          
                  ],),
          
                Text("15 May,2024 - 22 May,2024",style: blackPoppinsMedium17,),
                Text("11 am - 12 pm",style: blackPoppinsRegularr14,),
          
              ],),
            ),
          
                  SizedBox(height: 10.h,),
          
              TextField(
                maxLines: 5,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  filled: true, // Enables background color
                  fillColor: Clr.light_grey, // Background color
                  hintText: AppText.write_intruction,
                  hintStyle: grey919191PoppinsRegular14,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    borderSide: BorderSide.none, // Removes the default border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    borderSide: BorderSide.none, // Removes the border for enabled state
                  ),
                ),
              ),
                  SizedBox(height: 10.h,),
          
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      height: MediaQuery.of(context).size.width * 0.55,
      child: Column(
        children: [
          DottedBorder(
            color: Colors.black,
            strokeWidth: 1,
            radius : Radius.circular(20),
            borderType : BorderType.RRect,
            child: Container(
              padding:  EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppText.total,style: bluePoppinsRegular14,),
                      Text('\$161.00',style: blackPoppinsMedium14,)
                    ],),
                  SizedBox(height: 5.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppText.discount,style: TextStyle(
                          fontSize: 14.sp,
                          color: Clr.appColor,
                          fontFamily: Fonts.PoppinsRegular),),
                      Text('\$10.00',style: TextStyle(
                          fontSize: 14.sp,
                          color: Clr.appColor,
                          fontFamily: Fonts.PoppinsRegular),)
                    ],),
                  SizedBox(height: 5.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppText.net_amount_to_be_paid,style: bluePoppinsRegular14,),
                      Text('\$151.00',style: blackPoppinsMedium14,)
                    ],)
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h,),

          SizedBox(
            width: double.infinity,
            height: 45.h,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.APPOINT_SUCCESS);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Clr.appColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),),
              ),
              child: Text(AppText.pay_now,style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
            ),
          ),
        ],
      ),
    );
  }


}
