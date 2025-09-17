import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vteach_teacher/app/core/model/page_state.dart';
import 'package:vteach_teacher/app/core/utils/common_widgets.dart';
import '../../core/utils/DateFormat.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/utils/keyboard_types.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../core/widget/comman_textfield.dart';
import '/app/core/base/base_view.dart';
import 'request_appointment_detail_controller.dart';

class RequestAppointmentDetailView extends BaseView<RequestAppointmentDetailController> {

  RequestAppointmentDetailView({super.key});

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
            (controller.appointmentType == "1")  ? Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Clr.greenColor
              ),
              child: Text("Completed",style: TextStyle(
                  fontSize: 12.sp,
                  color: Clr.white,
                  fontFamily: Fonts.PoppinsMedium),),
            ) : SizedBox()
          ],),),
        Obx(() => (controller.isLoading.value) ? SizedBox() : Expanded(
          child: (controller.isNoData.value) ? SizedBox() : SingleChildScrollView(
            child: Obx(() => Container(
              padding:  EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 10.h,),

                  Text(
                      'BOOKING ID: ' +
                          controller.pendingBookingdata.value!.booking_number
                              .toString(),
                      style: greyPoppinsRegular12),

                  Obx(() => Text(DateFormats.convertDate24(controller.pendingBookingdata.value!.booking_at.toString(), DateFormats.dd_MM_yy_hh_mm_a), style: searchHintPoppinLight12,),),
                  SizedBox(height: 5.h,),

                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Clr.green200,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Text(controller.pendingBookingdata.value!.subjectTitle.toString(),style: blackPoppinsMedium12 ,)),

                  SizedBox(height: 5.h,),

                  Text(AppText.student_details,style: blackPoppinsLight12,),

                  SizedBox(height: 5.h,),

                  Row(
                    children: [
/*                      SizedBox(
                          height: 50.sp,
                          width: 50.sp,
                          //square box; equal height and width so that it won't look like oval
                          child: Image.asset(Drawables.dummy5)),*/
                      SizedBox(
                          height: 50.sp,
                          width: 50.sp,
                          //square box; equal height and width so that it won't look like oval
                          child: (controller.pendingBookingdata.value!.studentProfile == null || controller.pendingBookingdata.value!.studentProfile!.isEmpty) ? ClipOval(
                              child: Image.asset(Drawables.placeholder_photo,fit: BoxFit.cover,)) : ClipOval(
                              child: Image.network(controller.pendingBookingdata.value!.studentProfile.toString(),fit: BoxFit.cover,))),
                      SizedBox(width: 5.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.pendingBookingdata.value!.studentName.toString(),style: blackPoppinsMedium14,),
                          Text(controller.pendingBookingdata.value!.gradeTitle.toString(),style: blackPoppinsRegularr12,)
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(AppText.session_date_time,style: blackPoppinsLight12,),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.pendingBookingdata.value!.datetimeSlotsmodel!.length,
                            itemBuilder: (context, indexOuter) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5.h,),
                                  Text(DateFormats.convertDate(controller.pendingBookingdata.value!.datetimeSlotsmodel![indexOuter].date.toString() , DateFormats.yyyy_MM_dd, 'd MMMM yyyy'),style: blackPoppinsMedium14),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.pendingBookingdata.value!.datetimeSlotsmodel![indexOuter].timeslots?.length,
                                    itemBuilder: (context, indexInner) {
                                      return GestureDetector(
                                        onTap: (){
                                          if(controller.pendingBookingdata.value!.bookingStatus.toString() == "pending"){
                                            controller.pendingBookingdata.value!.datetimeSlotsmodel![indexOuter].timeslots![indexInner].isSelect.value = !controller.pendingBookingdata.value!.datetimeSlotsmodel![indexOuter].timeslots![indexInner].isSelect.value;
                                          }else{
                                            if(controller.fromNotification == "0"){
                                              controller.pendingBookingdata.value!.datetimeSlotsmodel![indexOuter].timeslots![indexInner].isSelect.value = !controller.pendingBookingdata.value!.datetimeSlotsmodel![indexOuter].timeslots![indexInner].isSelect.value;
                                            }
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 5.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(controller.pendingBookingdata.value!.datetimeSlotsmodel![indexOuter].timeslots![indexInner].time.toString(),style: blackPoppinsRegularr12),
                                              Obx(() => (controller.pendingBookingdata.value!.datetimeSlotsmodel![indexOuter].timeslots![indexInner].is_cancel == 0) ? (controller.pendingBookingdata.value!.datetimeSlotsmodel![indexOuter].timeslots![indexInner].isSelect.value) ? SvgPicture.asset(Drawables.tick_enable) : SvgPicture.asset(Drawables.tick_disable) : SvgPicture.asset(Drawables.tick_disable_grey,),)
                                            ],
                                          ),
                                        ),
                                      );
                                    },),
                                ],
                              );
                            },),
                        
                        ],),
                      ),

               /*       Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(AppText.appointments_dates,style: blackPoppinsRegularr12,),

                          SizedBox(height: 5.h,),

                          Row(children: [
                            Text('Multiple',style: blackPoppinsSemiBold12,),
                            SizedBox(width: 5.w,),
                            GestureDetector(
                              onTap: (){
                                openViewDatesDialog(context);
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


                  SizedBox(height: 20.h,),

/*                  Text(AppText.appointment_will_be_on_selected_dates,style: blackPoppinsLight12,),

                  Obx(() => SfDateRangePicker(
                    enablePastDates: false,
                    initialSelectedDate: (controller.initialSelectedDate!
                        .value.isNotEmpty) ? DateTime.parse(
                        controller.initialSelectedDate!.value) : null,
                    selectionMode: DateRangePickerSelectionMode.single,
                    backgroundColor: Clr.white,
                    minDate: controller.availableDateList[0],
                    maxDate: controller.availableDateList[controller.availableDateList.length - 1],
                    selectionColor: Clr.blackColor,
                    startRangeSelectionColor: Clr.blackColor,
                    endRangeSelectionColor: Clr.blackColor,
                    rangeSelectionColor: Clr.colorDFEFFC,
                    showNavigationArrow: true,
                    selectionTextStyle: TextStyle(color: Clr.white,
                        fontSize: 12.sp,
                        fontFamily: Fonts.PoppinsRegular),
                    view: DateRangePickerView.month,
                    headerHeight: MediaQuery
                        .of(context)
                        .size
                        .width * 0.20,
                    rangeTextStyle: TextStyle(color: Clr.blackColor,
                        fontSize: 12.sp,
                        fontFamily: Fonts.PoppinsRegular),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle: TextStyle(color: Clr.black,
                            fontFamily: Fonts.PoppinsRegular,
                            fontSize: 12.sp),
                        cellDecoration: BoxDecoration(
                          color: Clr.colorDFEFFC,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(color: Clr.blackColor,
                            fontFamily: Fonts.PoppinsRegular,
                            fontSize: 12.sp),
                        specialDatesDecoration: BoxDecoration(
                            color: Clr.blackColor,
                            shape: BoxShape.circle),
                        specialDatesTextStyle: TextStyle(color: Clr.white,
                            fontFamily: Fonts.PoppinsRegular,
                            fontSize: 12.sp)

                    ),
                    headerStyle: DateRangePickerHeaderStyle(
                        backgroundColor: Clr.white,
                        textAlign: TextAlign.left,
                        textStyle: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 20.sp,
                          fontFamily: Fonts.PoppinsSemiBold,
                          color: Clr.blackColor,
                        )),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          backgroundColor: Clr.white,
                          textStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 14.sp,
                            letterSpacing: 5,
                            fontFamily: Fonts.PoppinsSemiBold,
                            color: Clr.blackColor,
                          )),
                      specialDates: controller.availableDateList,),

                  ),),

                  SizedBox(height: 20.h,),*/

                  (controller.pendingBookingdata.value!.instruction == null || controller.pendingBookingdata.value!.instruction!.isEmpty) ? SizedBox() : Text(AppText.instruction,style: greyPoppinsLight12,),
                  (controller.pendingBookingdata.value!.instruction == null ||controller.pendingBookingdata.value!.instruction!.isEmpty) ?  SizedBox() : SizedBox(height: 10.h,),
                  (controller.pendingBookingdata.value!.instruction == null ||controller.pendingBookingdata.value!.instruction!.isEmpty) ?  SizedBox() : Text(controller.pendingBookingdata.value!.instruction ?? '',
                    style: bluePoppinsRegular14 ,),

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
                              Text(AppText.rate_per_hour,style: bluePoppinsRegular14,),
                              Text('\$'+controller.pendingBookingdata.value!.rate_per_hour.toString(),style: blackPoppinsRegular14,)
                            ],),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),),
          ),
        ),),
      ],
    );
  }


  @override
  Widget? bottomNavigationBar(BuildContext context) {
    return (controller.appointmentType == "0") ? Container(
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
    ) : Obx(() => (controller.pageState == PageState.LOADING) ? SizedBox() : (controller.pendingBookingdata.value!.bookingStatus.toString() == "pending") ? acceptRejectView(context) : (controller.fromNotification == "0") ? acceptRejectView(context) : SizedBox(),);
  }

  Container acceptRejectView(BuildContext context) {
    return Container(
    margin: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 45.h,
            child: ElevatedButton(
              onPressed: () {
                controller.callAcceptRejectService('accept',"",context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Clr.appColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),),
              ),
              child: Text(AppText.accept.toUpperCase(),style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
            ),
          ),
        ),
        SizedBox(width: 10.w,),
        Expanded(
          child: Container(
            height: 45.h,
            child: ElevatedButton(
              onPressed: () {
                openDialog(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Clr.blackColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),),
              ),
              child: Text(AppText.reject.toUpperCase(),style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
            ),
          ),
        )
      ],
    ),
  );
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
                  Text(AppText.reject_reason, style: blackPoppinsMediumm18),
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
                        controller.callAcceptRejectService('reject',controller.reasonController.text.toString(),context);
                        Get.back();
                      }else{
                        CommonUtils.getIntance().toastMessage(AppText.please_enter_reject_reason);
                      }
                    }else{
                      controller.callAcceptRejectService('reject',controller.reasonList[controller.selectedValue.value].reason.toString(),context);
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
                    AppText.reject_appointment,
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text(AppText.close,style: TextStyle(
                            fontSize: 16.sp,
                            color: Clr.borderColor,
                            fontFamily: Fonts.PoppinsRegular),),
                      ),
                      SizedBox(height: 10.h,),
                      SfDateRangePicker(
                          backgroundColor: Clr.white,
                          minDate: controller.availableDateList[0],
                          maxDate: controller.availableDateList[controller.availableDateList.length - 1],
                          view: DateRangePickerView.month,
                          monthCellStyle: DateRangePickerMonthCellStyle(
                              textStyle: TextStyle(color: Clr.black,fontFamily: Fonts.PoppinsRegular,fontSize: 12.sp),
                              cellDecoration: BoxDecoration(
                                  color: Clr.colorDFEFFC,
                                  shape: BoxShape.circle
                              ),
                              specialDatesTextStyle:TextStyle(color: Clr.white,fontFamily: Fonts.PoppinsRegular,fontSize: 12.sp) ,
                              todayTextStyle:TextStyle(color: Clr.white,fontFamily: Fonts.PoppinsRegular,fontSize: 12.sp),
                              specialDatesDecoration: BoxDecoration(
                                  color: Clr.blackColor,
                                  shape: BoxShape.circle)
                          ),
                          monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1,
                              viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                  backgroundColor: Clr.white,
                                  textStyle: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.sp,
                                    letterSpacing: 5,
                                    fontFamily: Fonts.PoppinsSemiBold,
                                    color: Clr.blackColor,
                                  )),
                              specialDates: controller.availableDateList)
                      ),
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
