import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vteach_teacher/app/core/model/page_state.dart';
import 'package:vteach_teacher/app/core/utils/DateFormat.dart';
import 'package:vteach_teacher/app/core/utils/image.dart';
import 'package:vteach_teacher/app/core/values/comman_text.dart';
import 'package:vteach_teacher/app/routes/app_pages.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/text_styles.dart';
import '/app/core/base/base_view.dart';
import 'home_controller.dart';

class HomeView extends BaseView<HomeController> {

  final ScrollController _scrollController = ScrollController();

  HomeView({super.key}) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !controller.isLoading.value &&
          controller.hasMoreData.value) {
        // Load next page when the user scrolls to the bottom
        controller.callGetPendingBooking(offset: controller.pendingBookingList.length);
      }
    });
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [

          Container(height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                SvgPicture.asset(Drawables.home_logo,height: 24.h,width: 24.w,),
                SizedBox(width: 10.w,),
                Text(AppText.appname.toUpperCase(),
                  style: appBarTitle,
                  textAlign: TextAlign.center,
                ),
                Expanded(child: Container()),
                InkWell(
                    onTap: () async {
                     var result = await Get.toNamed(Routes.NOTIFICATION);
                     if(result == true){
                       controller.isNotificationRead.value = 1;
                     }
                     // FlutterBackgroundService().invoke('start_video_call');
                    },
                    child: Obx(() => SvgPicture.asset( (controller.isNotificationRead.value == 1) ? Drawables.notification_icon_read : Drawables.notification_icon,height: 16.h,width: 16.w,),))
              ],),),

            Obx(() => (controller.isProfileApproved.value == 1) ? (controller.isSetAvailability.value == 1) ? list()  : setAvailabilityView(context) : (controller.pageState == PageState.LOADING) ? SizedBox() : notApproveView(),),


      ],),
    );
  }

  Widget list() {

    return Expanded(
      child: Obx(() => (controller.pendingBookingList.isNotEmpty) ?   RefreshIndicator(
          onRefresh: () async {
    controller.hasMoreData = true.obs;
    controller.currentPage = 1;
    controller.isLoading.value = false;
    controller.callGetPendingBooking();
    },
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: controller.pendingBookingList.length + 1,
          itemBuilder: (context, index) {

            if (index == controller.pendingBookingList.length) {
              // Show loading indicator at the bottom
              return controller.hasMoreData.value
                  ? Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator(
                  color: Clr.appColor,
                )),
              )
                  : SizedBox(); // No more data
            }

            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'BOOKING ID: ' +
                          controller.pendingBookingList[index].booking_number
                              .toString(),
                      style: greyPoppinsRegular12),
                  Row(
                    children: [
                     // Expanded(child: Text('14th May 2024,11:20 am', style: searchHintPoppinLight12,)),
                      Expanded(child: Text(DateFormats.convertDate24(controller.pendingBookingList[index].booking_at.toString(),DateFormats.dd_MM_yy_hh_mm_a), style: searchHintPoppinLight12,)),
                      // Other widgets can go here if needed
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
        /*                    SizedBox(
                          height: 60.sp,
                          width: 60.sp,
                          child: Image.asset(Drawables.dummy3, fit: BoxFit.cover,)
                      ),*/
                      SizedBox(
                          height: 50.sp,
                          width: 50.sp,
                          //square box; equal height and width so that it won't look like oval
                          child: (controller.pendingBookingList[index].student_profile == null || controller.pendingBookingList[index].student_profile!.isEmpty) ? ClipOval(
                              child: Image.asset(Drawables.placeholder_photo,fit: BoxFit.cover,)) : ClipOval(
                              child: Image.network(controller.pendingBookingList[index].student_profile.toString(),fit: BoxFit.cover,))),
                      SizedBox(width: 10.w,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.pendingBookingList[index].student_name.toString(), style: blackPoppinsSemibold16,),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Text(controller.pendingBookingList[index].grade_title.toString(), style: blackPoppinsRegularr12,),
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                 var result = await Get.toNamed(Routes.REQUEST_APPOINTMENT_DETAIL,arguments: controller.pendingBookingList[index].booking_id.toString(),parameters: {'fromNotification':"0"});
                                 if(result == true){
                                   controller.hasMoreData = true.obs;
                                   controller.currentPage = 1;
                                   controller.isLoading.value = false;
                                   controller.callGetPendingBooking();
                                 }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Clr.white,
                                        border: Border.all(color: Clr.grey_border)
                                    ),
                                    padding: EdgeInsets.all(7),
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(AppText.view_detail, style: TextStyle(
                                        fontSize: 8.sp,
                                        color: Clr.blackColor,
                                        fontFamily: Fonts.PoppinsSemiBold)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Clr.green200
                              ),
                              padding: EdgeInsets.all(7),
                              margin: EdgeInsets.only(right: 10),
                              child: Text(controller.pendingBookingList[index].subject_title.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Clr.blackColor,
                                  fontFamily: Fonts.PoppinsMedium)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ) : Obx(() => (controller.noDataMessage.value.isNotEmpty)  ? GestureDetector(
        onTap: (){
          controller.hasMoreData = true.obs;
          controller.currentPage = 1;
          controller.isLoading.value = false;
          controller.callGetCheckAvailabilityService();
        },
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(Icons.refresh,size: 24.sp,),

            SizedBox(height: 10.h,),

            Text(controller.noDataMessage.value,style: blackPoppinsMedium14,),
          ],
        )),
      ) : SizedBox(),)),
    );
  }


  Widget setAvailabilityView(BuildContext context){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Drawables.timetable,height: 100,width: 100,),
          SizedBox(height: 20.h,),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 45.h,
            child: ElevatedButton(
              onPressed: () async {
                var result = await Get.toNamed(Routes.AVAILABILITY,arguments: "0");
                if(result == true){
                  controller.callGetCheckAvailabilityService();
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Clr.blackColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),),
              ),
              child: Text(AppText.set_availablity,style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),
            ),
          )
        ],
      ),
    );
  }

  Widget notApproveView(){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Drawables.home_teacher,height: 120,width: 120,),
          SizedBox(height: 10.h,),
          Text("Hey ${controller.teacherName},${AppText.not_approved_msg}",style: TextStyle(
              fontSize: 14.sp,
              color: Clr.blackColor,
              fontFamily: Fonts.PoppinsRegular),
          textAlign: TextAlign.center,)
        ],
      ),
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
                  color: Colors.white,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppText.view_details,style: blackPoppinsMediumm18,),
                          InkWell(
                            onTap: (){
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
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey[200]!)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: 60.sp,
                                width: 60.sp,
                                //square box; equal height and width so that it won't look like oval
                                child: Image.asset(Drawables.dummy3,fit: BoxFit.cover,)),
                            SizedBox(width: 10.w,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Kade Lee',style: blackPoppinsSemibold16,),
                                  Text('Grade: 7',style: blackPoppinsRegularr12,),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Clr.green200
                              ),
                              padding: EdgeInsets.all(7),
                              margin: EdgeInsets.only(right: 10),
                              child: Text('Biology',style:  TextStyle(
                                  fontSize: 12.sp,
                                  color: Clr.blackColor,
                                  fontFamily: Fonts.PoppinsMedium)),
                            )
                          ],
                        ),
                      ),
                      SfDateRangePicker(
                        backgroundColor: Clr.white,
                        view: DateRangePickerView.month,
                        monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
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
