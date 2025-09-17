import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../core/utils/DateFormat.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/utils/keyboard_types.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../core/widget/comman_textfield.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';
import 'appointment_detail_controller.dart';

class AppointmentDetailView extends BaseView<AppointmentDetailController> {

  AppointmentDetailView({super.key});

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
            Text(AppText.detail,
              style: appBarTitle,
              textAlign: TextAlign.center,
            ),
            Expanded(child: Container(),),
            Obx(() => (controller.appointmentType.value == "1")  ? Obx(() => (controller.bookingData.value == null) ? SizedBox() : Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: (controller.bookingData.value!.bookingStatus.toString() == "rejected" ||
                      controller.bookingData.value!.bookingStatus.toString() == "cancel") ? Clr.redDarkColor : Clr.greenColor),
              child: Text( (controller.bookingData.value!.cancel_by.toString() == "cancel") ? "Cancelled" : (controller.bookingData.value!.cancel_by.toString() == "Cancel By student") ? "Cancelled By student" : controller.bookingData.value!.cancel_by.toString(),
                style: TextStyle(
                    fontSize: 12.sp,
                    color: Clr.white,
                    fontFamily: Fonts.PoppinsMedium),),
            ),): SizedBox(),)
          ],),),
        Expanded(
          // added by rajnikant
          child: RefreshIndicator(
            onRefresh: () async {
              controller.callGetBookingDetailService();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Obx(() => (controller.bookingData.value == null) ? SizedBox() : Container(
                padding:  EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 10.h,),

                    // Text('Id: 232326565, 15/05/24, 11:05 am',style: blackPoppinsLight12,),
                  //  Text('ID: '+controller.bookingData.value!.bookingNumber.toString()+" "+DateFormats.convertDateTime(controller.bookingData.value!.bookingAt.toString(), "yyyy-MM-dd hh:mm:ss", DateFormats.dd_MM_yy_hh_mm_a),style:  blackPoppinsLight12),
                    Text(
                        'BOOKING ID: ' +
                            controller.bookingData.value!.bookingNumber
                                .toString(),
                        style: greyPoppinsRegular12),
                    Text(
                        'APPOINTMENT ID: ' +
                            controller.bookingData.value!.booking_slot_number
                                .toString(),
                        style: greyPoppinsRegular12),
                    Text(DateFormats.convertDate24(controller.bookingData.value!.bookingAt.toString(),DateFormats.dd_MM_yy_hh_mm_a),style:  blackPoppinsLight12),
                    SizedBox(height: 5.h,),

            /*                  Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Clr.green200,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Text('Biology',style: blackPoppinsMedium12 ,)),*/

                    Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Clr.green200,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Text(controller.bookingData.value!.subjectTitle.toString(),style: blackPoppinsMedium12 ,)),

                    SizedBox(height: 10.h,),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppText.session_date_time,style: blackPoppinsLight12,),

                              SizedBox(height: 5.h,),

                              // Text("8 May 2024",style: blackPoppinsMedium17,),

                              Text(DateFormats.convertDate(controller.bookingData.value!.date.toString(),DateFormats.yyyy_MM_dd,'dd MMMM yyyy'))


                            ],),
                        ),
            /*                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(AppText.appointments_dates,style: blackPoppinsRegularr12,),

                            SizedBox(height: 5.h,),

                            Row(children: [
                              Text('Multiple',style: blackPoppinsSemiBold12,),
                              SizedBox(width: 5.w,),
                              GestureDetector(
                                onTap: (){
                                  // openViewDatesDialog(context);
                                },
                                child: Text('View',style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Clr.color2020f2,
                                    fontFamily: Fonts.PoppinsRegular),),
                              ),
                            ],)

                          ],),*/
                      ],
                    ),

                    SizedBox(height: 5.h,),

                    Text(controller.bookingData.value!.time.toString(),style: blackPoppinsRegularr14,),


                    SizedBox(height: 20.h,),

                    Text(AppText.student_details,style: blackPoppinsLight12,),

                    SizedBox(height: 5.h,),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 50.sp,
                            width: 50.sp,
                            //square box; equal height and width so that it won't look like oval
                            child: (controller.bookingData.value!.studentProfile == null || controller.bookingData.value!.studentProfile!.isEmpty) ? ClipOval(
                                child: Image.asset(Drawables.placeholder_photo,fit: BoxFit.cover,)) : ClipOval(
                                child: Image.network(controller.bookingData.value!.studentProfile.toString(),fit: BoxFit.cover,))),
                        SizedBox(width: 5.w,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.bookingData.value!.studentName.toString(),style: blackPoppinsMedium14,),
                              Text(controller.bookingData.value!.gradeTitle.toString(),style: blackPoppinsRegularr12,)
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                          (controller.bookingData.value!.bookingStatus.toString() == "completed")  ? (controller.bookingData.value!.rating.toString() == "0.0") ? SizedBox() : InkWell(
                            onTap: (){
                              openViewDatesDialog(context);
                            },
                            child: Text(AppText.view_rate_review,style: TextStyle(
                                fontSize: 12.sp,
                                color: Clr.blue,
                                decoration: TextDecoration.underline,
                                decorationColor: Clr.blue,
                                fontFamily: Fonts.PoppinsMedium),),
                          ) : SizedBox(),

                            Obx(() => (controller.appointmentType.value == "0" || controller.bookingData.value!.bookingStatus.toString() == "completed") ? SizedBox(height: 10.h,) : SizedBox(),),

                            Obx(() => (controller.appointmentType.value == "0" || controller.bookingData.value!.bookingStatus.toString() == "completed") ? InkWell(
                                onTap: (){
                                  Get.toNamed(Routes.CHAT,parameters: {
                                    'student_id' : controller.bookingData.value!.student_id.toString(),
                                    'booking_id' : controller.bookingId,
                                    'booking_slot_id' : controller.bookingSlotId,
                                    'student_name' : controller.bookingData.value!.studentName.toString(),
                                  });
                                },
                                child: Icon(Icons.chat , size: 22.sp,)) : SizedBox(),)
                        ],)
                      ],
                    ),

                    SizedBox(height: 15.h,),

                    (controller.bookingData.value!.cancelReason!.isNotEmpty) ?  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (controller.bookingData.value!.bookingStatus == "rejected") ? Text(AppText.reject_reason ,style: blackPoppinsLight12,) : (controller.bookingData.value!.auto_cancel == 0) ? Text(AppText.cancel_reason ,style: blackPoppinsLight12,) : SizedBox(),

                      SizedBox(height: 3.h,),

                        (controller.bookingData.value!.bookingStatus == "rejected") ?  Text(controller.bookingData.value!.cancelReason.toString(),style: TextStyle(
                            fontSize: 12.sp,
                            color: Clr.redColor,
                            fontFamily: Fonts.PoppinsRegular),) :
                        (controller.bookingData.value!.auto_cancel == 0) ? Text(controller.bookingData.value!.cancelReason.toString(),style: TextStyle(
                            fontSize: 12.sp,
                            color: Clr.redColor,
                            fontFamily: Fonts.PoppinsRegular),) : Text(controller.bookingData.value!.cancelReason.toString(),style: TextStyle(
                            fontSize: 12.sp,
                            color: Clr.redColor,
                            fontFamily: Fonts.PoppinsRegular),),

                      SizedBox(height: 20.h,),
                    ],) : SizedBox(),

                    (controller.bookingData.value!.instruction!.isNotEmpty) ? Text(AppText.instruction,style: greyPoppinsLight12,) : SizedBox(),
                    (controller.bookingData.value!.instruction!.isNotEmpty) ?  SizedBox(height: 10.h,) : SizedBox(),
                    (controller.bookingData.value!.instruction!.isNotEmpty) ?   Text(controller.bookingData.value!.instruction.toString(),
                      style: bluePoppinsRegular14 ,) : SizedBox(),

                    SizedBox(height: 10.h,),

                    DottedBorder(
                      color: Clr.greyColor,
                      strokeWidth: 1,
                      radius : Radius.circular(20),
                      borderType : BorderType.RRect,
                      dashPattern: [4,2],
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
                                Text('\$'+controller.bookingData.value!.amount.toString(),style: blackPoppinsRegular14,)
                              ],),
                            SizedBox(height: 5.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppText.discount,style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Clr.appColor,
                                    fontFamily: Fonts.PoppinsRegular),),
                                Text('\$'+controller.bookingData.value!.discount.toString(),style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Clr.appColor,
                                    fontFamily: Fonts.PoppinsRegular),)
                              ],),
                            SizedBox(height: 5.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppText.net_amount_to_be_paid,style: bluePoppinsRegular14,),
                                Text('\$'+controller.bookingData.value!.payableAmount.toString(),style: blackPoppinsMedium17,)
                              ],)
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h,),

                   /* Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(AppText.payment,style: blackPoppinsLight12,),
                            Text(controller.bookingData.value!.paymentStatus.toString(),style: TextStyle(
                                fontSize: 14.sp,
                                color: Clr.greenColor,
                                fontFamily: Fonts.PoppinsMedium),),
                          ],
                        ),
                        Column(
                          children: [
                            Text(AppText.upi_transaction,style: blackPoppinsRegularr12,),
                            Text("Ref Id: "+controller.bookingData.value!.transactionId.toString(),style: blackPoppinsRegularr10,),
                          ],
                        ),
                      ],
                    ),*/

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(AppText.call_history,style: blackPoppinsBold14,),
                        InkWell(onTap: (){
                          Get.toNamed(Routes.CALL_DETAIL,arguments: controller.bookingData.value!.bookingSlotId);
                        },
                          child: Text(AppText.view,style: TextStyle(
                              fontSize: 14.sp,
                              color: Clr.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Clr.blue,
                              fontFamily: Fonts.PoppinsMedium),),
                        ),
                      ],
                    ),
            /*                  Obx(() => (controller.isChatShow.value) ? SizedBox(height: 10.h,) : SizedBox(),),
                    Obx(() => (controller.isChatShow.value) ?
                    InkWell(onTap: (){
                      Get.toNamed(Routes.CHAT,arguments: controller.bookingData.value);
                    },
                      child: Text("Chat",style: TextStyle(
                          fontSize: 16.sp,
                          color: Clr.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Clr.blue,
                          fontFamily: Fonts.PoppinsMedium),),
                    ) : SizedBox(),),*/

                    SizedBox(height: 50.h,),
                  ],
                ),
              ),),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return Obx(() => (controller.appointmentType.value == "0") ? Container(
      height: 150,
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 45.h,
            child: ElevatedButton(
              onPressed: () {
                //Get.toNamed(Routes.APPOINT_SUCCESS);
                // controller.requestPermissions();
                //controller.callSendNotificationService();
                controller.checkPermissions();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Clr.blackColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),),
              ),
              child: Text(AppText.start_session.toUpperCase(),style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
            ),
          ),
          SizedBox(height: 10.h,),
          Container(
            width: double.infinity,
            height: 45.h,
            child: ElevatedButton(
              onPressed: () {
                openDialog(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Clr.redDarkColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),),
              ),
              child: Text(AppText.cancel_appointment,style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
            ),
          ),
        ],
      ),
    ) : SizedBox(),);
  }

  openDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Clr.white,
      isScrollControlled: true,  // Add this line
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 15,
            right: 15,
            top: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppText.cancel_reason, style: blackPoppinsMediumm18),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppText.close,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Clr.borderColor,
                        fontFamily: Fonts.PoppinsRegular,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Flexible(
                child: ListView.builder(
                  itemCount: controller.reasonList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        controller.selectedValue.value = index;
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Obx(() => controller.selectedValue.value == index
                                ? SvgPicture.asset(Drawables.radio_on)
                                : SvgPicture.asset(Drawables.radio_off)),
                            SizedBox(width: 5.w),
                            Text(
                              controller.reasonList[index].reason.toString(),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Clr.black171717,
                                fontFamily: Fonts.PoppinsRegular,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Obx(() => (controller.selectedValue.value == controller.reasonList.length - 1) ?
              CommanTextField(
                hint: "",
                label: AppText.reason,
                keyboardType: KeyboardComman.NAME,
                inputAction: KeyboardComman.NEXT,
                maxlines: 1,
                controller: controller.reasonController,
              ) : SizedBox(),),
              Obx(() => (controller.selectedValue.value == controller.reasonList.length - 1) ? SizedBox(height: 20.h) : SizedBox(),),
              Container(
                width: double.infinity,
                height: 45.h,
                child: ElevatedButton(
                  onPressed: () {
                    if(controller.selectedValue.value == controller.reasonList.length - 1){
                      if(controller.reasonController.text.isNotEmpty){
                        controller.callCancelAppointmentService(controller.reasonController.text.toString());
                        Get.back();
                      }else{
                        CommonUtils.getIntance().toastMessage(AppText.please_enter_cancel_reason);
                      }
                    }else{
                      controller.callCancelAppointmentService(controller.reasonList[controller.selectedValue.value].reason.toString());
                      Get.back();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Clr.redDarkColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  child: Text(
                    AppText.cancel_appointment,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Clr.white,
                      fontFamily: Fonts.PoppinsMedium,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  void openViewDatesDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (BuildContext context) {
        return Dialog(
          child:SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Clr.viewBg,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppText.view_rate_review,style: TextStyle(
                              fontSize: 14.sp,
                              color: Clr.blackColor,
                              fontFamily: Fonts.PoppinsRegular),),
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Text(AppText.close,style: TextStyle(
                                fontSize: 14.sp,
                                color: Clr.borderColor,
                                fontFamily: Fonts.PoppinsRegular),),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h,),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                    height: 50.sp,
                                    width: 50.sp,
                                    //square box; equal height and width so that it won't look like oval
                                    child: (controller.bookingData.value!.studentProfile == null || controller.bookingData.value!.studentProfile!.isEmpty) ? ClipOval(
                                        child: Image.asset(Drawables.placeholder_photo,fit: BoxFit.cover,)) : ClipOval(
                                        child: Image.network(controller.bookingData.value!.studentProfile.toString(),fit: BoxFit.cover,))),
                                SizedBox(width: 5.w,),
                                Flexible(child: Text(controller.bookingData.value!.studentName.toString(),style: blackPoppinsMedium12,)),
                            
                                SizedBox(width: 5.w,),
                                
                                SvgPicture.asset(Drawables.rate_enable,width: 14.w,height: 14.h,),
                            
                                SizedBox(width: 5.w,),
                            
                                Text(controller.bookingData.value!.rating.toString(),style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Clr.borderColor,
                                    fontFamily: Fonts.PoppinsRegular),),
                            

                              ],
                            ),
                          ),
                          SizedBox(width: 5.h,),
                          Text(DateFormats.convertDateTime(controller.bookingData.value!.review_created_at.toString(), DateFormats.yyyy_MM_dd_hh_mm_ss, DateFormats.dd_MM_yy_hh_mm_a),style: TextStyle(
                              fontSize: 10.sp,
                              color: Clr.borderColor,
                              fontFamily: Fonts.PoppinsRegular),)
                        ],
                      ),
                      SizedBox(height: 5.h,),
                      (controller.bookingData.value!.review!.isNotEmpty) ?  Text(controller.bookingData.value!.review.toString(),style: TextStyle(
                          fontSize: 12.sp,
                          color: Clr.borderColor,
                          fontFamily: Fonts.PoppinsRegular),) : SizedBox()
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

}
