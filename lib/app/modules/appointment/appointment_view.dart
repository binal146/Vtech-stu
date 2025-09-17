import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:vteach_teacher/app/core/values/comman_text.dart';
import '../../core/utils/DateFormat.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/values/text_styles.dart';
import '../../routes/app_pages.dart';
import '../bottom__navigation_bar/BottomNavController.dart';
import '/app/core/base/base_view.dart';
import 'appointment_controller.dart';

class AppointMentView extends BaseView<AppoinmentController> {

  final ScrollController _scrollController = ScrollController();

  AppointMentView({super.key}) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !controller.isLoading.value &&
          controller.hasMoreData.value) {
        //controller.callGetNotificationListService(offset: controller.notificationList.length);
        if(controller.isUpcoming.value){
          controller.callGetBookingService('upcoming',offset: controller.bookingList.length);
        }else{
          controller.callGetBookingService('past',offset: controller.bookingList.length);
        }
      }
    });
  }

  late Map<String, dynamic> data;



  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: Column(
        children: [
          Container(height: 40.h,
            padding: EdgeInsets.only(left: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(AppText.appoinments,
                style: appBarTitle,
                textAlign: TextAlign.center,
              ),
            ),),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              border: Border.all(color: Clr.grey_border)
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [

                Obx(() =>  (controller.isUpcoming == true) ?
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Clr.blackColor
                      ),
                      child : Text(AppText.upcoming,style:TextStyle(
                          fontSize: 14.sp,
                          color: Clr.white,
                          fontFamily: Fonts.PoppinsMedium),
                        textAlign: TextAlign.center,)
                  ),
                ) : Expanded(
                  child: GestureDetector(
                    onTap: (){
                      controller.isUpcoming.value = !controller.isUpcoming.value;
                      controller.selectedFilter.value = 0;
                      controller.hasMoreData = true.obs;
                      controller.currentPage = 1;
                      controller.isLoading.value = false;
                      controller.callGetBookingService('upcoming');
                    },
                    child: Text(AppText.upcoming,style:TextStyle(
                        fontSize: 14.sp,
                        color: Clr.greyColor,
                        fontFamily: Fonts.PoppinsMedium),
                      textAlign: TextAlign.center,),
                  ),
                ),),


                Obx(() =>  (controller.isUpcoming == false) ?
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Clr.blackColor
                      ),
                      child : Text(AppText.past,style:TextStyle(
                          fontSize: 14.sp,
                          color: Clr.white,
                          fontFamily: Fonts.PoppinsMedium),
                        textAlign: TextAlign.center,)
                  ),
                ) : Expanded(
                  child: GestureDetector(
                    onTap: (){
                      print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
                      controller.isUpcoming.value = !controller.isUpcoming.value;
                      controller.hasMoreData = true.obs;
                      controller.currentPage = 1;
                      controller.isLoading.value = false;
                      controller.callGetBookingService('past');
                    },
                    child: Text(AppText.past,style:TextStyle(
                        fontSize: 14.sp,
                        color: Clr.greyColor,
                        fontFamily: Fonts.PoppinsMedium),
                      textAlign: TextAlign.center,),
                  ),
                ),),
            ],),
          ),
          Obx(() => (controller.isUpcoming.value == true) ? SizedBox() : SizedBox(height: 15.h,),),
          Obx(() => (controller.isUpcoming.value == true) ? SizedBox() : GestureDetector(
            onTap: (){
              openDialog(context);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      color: Clr.green400
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => (controller.isFilterApply.value == true) ?Container(
                        height:10,
                        width: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Clr.redDark
                        ),
                      ) : SizedBox(),),
                      SizedBox(width: 5.w,),
                      Text(AppText.filter,style:  TextStyle(
                          fontSize: 14.sp,
                          color: Clr.blackColor,
                          fontFamily: Fonts.PoppinsMedium)),
                      SizedBox(width: 5.w,),
                      SvgPicture.asset(Drawables.filter)
                    ],
                  )
              ),
            ),
          ),),
          SizedBox(height: 10.h,),
          Expanded(child: Obx(() => RefreshIndicator(child: (controller.isUpcoming.value == true) ? upcomingViiew() : pastView(),
              onRefresh: () async{
                controller.hasMoreData = true.obs;
                controller.currentPage = 1;
                controller.isLoading.value = false;
            if(controller.isUpcoming.value){
              controller.callGetBookingService('upcoming');
            }else{
              controller.callGetBookingService('past');
            }

              },)))
        ],
      ),
    );
  }


  Widget upcomingViiew(){
    return Obx(() => (controller.bookingList.isNotEmpty) ? ListView.builder(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: controller.bookingList.length + 1,
      itemBuilder: (context, index) {
        if (index == controller.bookingList.length) {
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
        return GestureDetector(
          onTap: () async {
         var result = await Get.toNamed(Routes.APPOINTMENT_DETAIL,parameters: {
              'type':'0',
              'bookingId': controller.bookingList[index].booking_id.toString(),
              'bookingSlotId': controller.bookingList[index].bookingSlotId.toString(),
              'open_call_history' : "0"
              ,});
         if(result == true){

           if(controller.isUpcoming.value) {
             controller.hasMoreData = true.obs;
             controller.currentPage = 1;
             controller.isLoading.value = false;
             controller.callGetBookingService('upcoming');

             Future.delayed(Duration(seconds: 1),() {
               BottomNavController bottomNavController = Get.put(BottomNavController(), permanent: false);
               if(bottomNavController.bookingId.isNotEmpty && bottomNavController.bookingSlotId.isNotEmpty){
                 Get.toNamed(Routes.APPOINTMENT_DETAIL,parameters: {
                   'type':'1',
                   'bookingId': bottomNavController.bookingId,
                   'bookingSlotId': bottomNavController.bookingSlotId,
                   'open_call_history' : "0"
                   ,});
               }
             },);

           }else{
             controller.hasMoreData = true.obs;
             controller.currentPage = 1;
             controller.isLoading.value = false;
             controller.callGetBookingService('past');

             Future.delayed(Duration(seconds: 1),() {
               BottomNavController bottomNavController = Get.put(BottomNavController(), permanent: false);
               if(bottomNavController.bookingId.isNotEmpty && bottomNavController.bookingSlotId.isNotEmpty){
                 Get.toNamed(Routes.APPOINTMENT_DETAIL,parameters: {
                   'type':'1',
                   'bookingId': bottomNavController.bookingId,
                   'bookingSlotId': bottomNavController.bookingSlotId,
                   'open_call_history' : "0"
                   ,});
               }
             },);
           }
         }
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!),
                color: Clr.viewBg
            ),
            child: upcoming(index),
          ),
        );
      },) : Obx(() => (controller.emptyMessage.value.isNotEmpty) ? GestureDetector(
      onTap: (){
        controller.hasMoreData = true.obs;
        controller.currentPage = 1;
        controller.isLoading.value = false;
        controller.callGetBookingService('upcoming');
      },
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(Icons.refresh,size: 24.sp,),

          SizedBox(height: 10.h,),

          Text(controller.emptyMessage.value,style: blackPoppinsMedium14,),
        ],
      )),
    ) : SizedBox(),) ,);
  }


  Widget pastView(){
    return Obx(() => (controller.bookingList.isNotEmpty) ? ListView.builder(
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: controller.bookingList.length + 1,
      itemBuilder: (context, index) {
        if (index == controller.bookingList.length) {
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


        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.APPOINTMENT_DETAIL,arguments: controller.bookingList[index],parameters: {
              'type':'1',
              'bookingId': controller.bookingList[index].booking_id.toString(),
              'bookingSlotId': controller.bookingList[index].bookingSlotId.toString(),
              'open_call_history' : "0"
            });
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!),
                color: Clr.viewBg
            ),
            child: (controller.bookingList[index].bookingStatus == 'cancel') ? cancelledView(index) : completedView(index) ,
          ),
        );
      },) :
    Obx(() => (controller.emptyMessage.value.isNotEmpty) ? GestureDetector(
      onTap: (){
        controller.hasMoreData = true.obs;
        controller.currentPage = 1;
        controller.isLoading.value = false;
        controller.callGetBookingService('past');
      },
      child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(Icons.refresh,size: 24.sp,),

          SizedBox(height: 10.h,),

          Text(controller.emptyMessage.value,style: blackPoppinsMedium14,),
        ],
      )),
    ) : SizedBox(),),);
  }


  openDialog(BuildContext context){
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
                  Text(AppText.filter_by,style: blackPoppinsMediumm18,),
                  GestureDetector(
                    onTap: (){
                      controller.selectedFilter.value = 0;
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
              Flexible(
                child: ListView.builder(
                  itemCount: filterList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        controller.selectedFilter.value = index;
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Obx(() => (controller.selectedFilter == index) ?  SvgPicture.asset(Drawables.radio_on) : SvgPicture.asset(Drawables.radio_off),),
                            SizedBox(width: 5.w,),
                            Text(filterList[index],style: TextStyle(
                                fontSize: 16.sp,
                                color: Clr.black171717,
                                fontFamily: Fonts.PoppinsRegular),),
                          ],
                        ),
                      ),
                    );
                  },),
              ),
              SizedBox(height: 10.h,),
              Container(
                width: double.infinity,
                height: 45.h,
                child: ElevatedButton(
                  onPressed: () {
                    controller.isFilterApply.value = !controller.isFilterApply.value;
                    Navigator.pop(context);
                    controller.callGetBookingService("past");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Clr.appColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),),
                  ),
                  child: Obx(() => Text((controller.isFilterApply.value) ? AppText.reset_filter : AppText.apply,style:  TextStyle(fontSize: 16.sp,color: Clr.white,fontFamily: Fonts.PoppinsMedium),),)
                ),
              )
            ],
          ),
        );
      },
    );

  }

  static const List<String> filterList = [
    'All',
    'Cancelled Appointments',
    'Rejected Appointments',
    'Completed Appointments',
  ];

  Widget completedView(int index){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Text('Id: 232326565, 15/05/24, 11:05 am',style: blackPoppinsLight12,),
        //Text('ID: '+controller.bookingList[index].booking_number.toString()+" "+DateFormats.convertDateTime(controller.bookingList[index].booking_at.toString(), "yyyy-MM-dd HH:mm:ss", DateFormats.dd_MM_yy_hh_mm_a),style:  blackPoppinsLight12),
        Text(
            'BOOKING ID: ' +
                controller.bookingList[index].booking_number
                    .toString(),
            style: greyPoppinsRegular12),
        Text(
            'APPOINTMENT ID: ' +
                controller.bookingList[index].booking_slot_number
                    .toString(),
            style: greyPoppinsRegular12),
        Text(DateFormats.convertDate24(controller.bookingList[index].booking_at.toString(), DateFormats.dd_MM_yy_hh_mm_a),style:  blackPoppinsLight12),
        SizedBox(height: 5.h,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Clr.green200
                ),
                padding: EdgeInsets.all(10),
                child: Text(controller.bookingList[index].subjectTitle.toString(),
                    maxLines:1,
                    style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                    fontFamily: Fonts.PoppinsRegular)),
              ),
            ),

            SizedBox(width: 5.w,),

            Expanded(
              flex: 1,
              child: Row(children: [
                SizedBox(
                    height: 40.sp,
                    width: 40.sp,
                    //square box; equal height and width so that it won't look like oval
                    child: (controller.bookingList[index].studentProfile != null && controller.bookingList[index].studentProfile!.isNotEmpty) ? ClipOval(child: Image.network(controller.bookingList[index].studentProfile.toString(),fit: BoxFit.cover,)) : ClipOval(
                      child: Image.asset(
                        Drawables.placeholder_photo, fit: BoxFit.cover,),
                    )),
                SizedBox(width: 5.w,),

                Flexible(
                  child: Text(controller.bookingList[index].studentName.toString(),
                    maxLines:2,
                    overflow: TextOverflow.ellipsis,
                    style: blackPoppinsRegular14,),
                )
              ],),
            ),
          ],),

        SizedBox(height: 10.h,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: '+DateFormats.convertDate(controller.bookingList[index].date.toString(), DateFormats.yyyy_MM_dd, 'd MMMM yyyy'),
                    style: blackPoppinsSemiBold13,),
                  SizedBox(height: 5.h,),
                  Text(controller.bookingList[index].time.toString(),
                    style: blackPoppinsRegularr12,)
                ],),
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(Get.context!).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: (controller.bookingList[index].bookingStatus == "completed") ? Clr.greenColor : (controller.bookingList[index].bookingStatus == "pending") ? Clr.pendingColor : Clr.colorce191a
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10),
                child: Center(
                  child: Text(controller.bookingList[index].bookingStatus.toString(), style: TextStyle(
                      fontSize: 10.sp,
                      color: Clr.white,
                      fontFamily: Fonts.PoppinsMedium)),
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }

  Widget cancelledView(int index){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
            'BOOKING ID: ' +
                controller.bookingList[index].booking_number
                    .toString(),
            style: greyPoppinsRegular12),
        Text(
            'APPOINTMENT ID: ' +
                controller.bookingList[index].booking_slot_number
                    .toString(),
            style: greyPoppinsRegular12),
        Text(DateFormats.convertDate24(controller.bookingList[index].booking_at.toString(),  DateFormats.dd_MM_yy_hh_mm_a),style:  blackPoppinsLight12),
        SizedBox(height: 5.h,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Clr.green200.withOpacity(0.61),
                ),
                padding: EdgeInsets.all(10),
                child: Text(controller.bookingList[index].subjectTitle.toString(),
                    maxLines:1,style: TextStyle(
                    fontSize: 14.sp,
                        overflow: TextOverflow.ellipsis,
                    color: Colors.black.withOpacity(0.61),
                    fontFamily: Fonts.PoppinsRegular)),
              ),
            ),

            SizedBox(width: 5.w,),

            Expanded(
              flex: 1,
              child: Row(children: [
                SizedBox(
                    height: 40.sp,
                    width: 40.sp,
                    //square box; equal height and width so that it won't look like oval
                    child: (controller.bookingList[index].studentProfile != null && controller.bookingList[index].studentProfile!.isNotEmpty) ? ClipOval(child: Image.network(controller.bookingList[index].studentProfile.toString(),fit: BoxFit.cover,)) : ClipOval(
                      child: Image.asset(
                        Drawables.placeholder_photo, fit: BoxFit.cover,),
                    )),

                SizedBox(width: 5.w,),

                Flexible(
                  child: Text(controller.bookingList[index].studentName.toString(),
                    maxLines:2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Clr.blackColor.withOpacity(0.61),
                      fontFamily: Fonts.PoppinsMedium),),
                )

              ],),
            ),
          ],),

        SizedBox(height: 10.h,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: '+DateFormats.convertDate(controller.bookingList[index].date.toString(), DateFormats.yyyy_MM_dd, 'd MMMM yyyy'),
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Clr.blackColor.withOpacity(0.61),
                        fontFamily: Fonts.PoppinsSemiBold),),
                  SizedBox(height: 5.h,),
                  Text(controller.bookingList[index].time.toString(),
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Clr.greyColor.withOpacity(0.61),
                        fontFamily: Fonts.PoppinsLight),)
                ],),
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(Get.context!).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: (controller.bookingList[index].bookingStatus == "completed") ? Clr.greenColor : (controller.bookingList[index].bookingStatus == "pending") ? Clr.pendingColor : Clr.colorce191a
                ),
                padding: EdgeInsets.all(9),
                margin: EdgeInsets.only(left: 10),
                child: Center(
                  child: Text((controller.bookingList[index].cancel_by.toString() == "cancel") ? "Cancelled" : (controller.bookingList[index].cancel_by.toString() == "Cancel By student") ? "Cancelled By student" : controller.bookingList[index].cancel_by.toString(), style: TextStyle(
                      fontSize: 10.sp,
                      color: Clr.white,
                      fontFamily: Fonts.PoppinsRegular)),
                ),
              ),
            ),

          ],
        ),

        SizedBox(height: 10.h,),

        (controller.bookingList[index].auto_cancel == 0 && controller.bookingList[index].cancelReason!.isNotEmpty) ?
        Text(AppText.cancellation_reason_lower,
          style: TextStyle(
              fontSize: 11.sp,
              color: Clr.blackColor.withOpacity(0.61),
              fontFamily: Fonts.PoppinsRegular),) : SizedBox(),

        (controller.bookingList[index].cancelReason!.isNotEmpty) ?
        (controller.bookingList[index].auto_cancel == 0)  ?  Text(controller.bookingList[index].cancelReason.toString(),
          style: TextStyle(
              fontSize: 12.sp,
              color: Clr.redColor,
              fontFamily: Fonts.PoppinsRegular),) : Text(controller.bookingList[index].cancelReason.toString(),
          style: TextStyle(
              fontSize: 13.sp,
              color: Clr.redColor,
              fontFamily: Fonts.PoppinsMedium),) : SizedBox(),
      ],
    );
  }

  Widget upcoming(int index){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'BOOKING ID: ' +
                controller.bookingList[index].booking_number
                    .toString(),
            style: greyPoppinsRegular12),
        Text(
            'APPOINTMENT ID: ' +
                controller.bookingList[index].booking_slot_number
                    .toString(),
            style: greyPoppinsRegular12),
        Text(DateFormats.convertDate24(controller.bookingList[index].booking_at.toString(), DateFormats.dd_MM_yy_hh_mm_a),style:  blackPoppinsLight12),
        SizedBox(height: 5.h,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // First Part
            Expanded(
              flex: 1, // Adjust the flex value to control space allocation
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Clr.green200,
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  controller.bookingList[index].subjectTitle.toString(),
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.black,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: Fonts.PoppinsMedium,
                  ),
                ),
              ),
            ),
            // Second Part
            Expanded(
              flex: 1, // Adjust the flex value as needed
              child: Row(
                children: [
                  SizedBox(
                    height: 40.sp,
                    width: 40.sp,
                    child: (controller.bookingList[index].studentProfile != null &&
                        controller.bookingList[index].studentProfile!.isNotEmpty)
                        ? ClipOval(
                      child: Image.network(
                        controller.bookingList[index].studentProfile.toString(),
                        fit: BoxFit.cover,
                      ),
                    )
                        : ClipOval(
                      child: Image.asset(
                        Drawables.placeholder_photo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Flexible(
                    child: Text(
                      controller.bookingList[index].studentName.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: blackPoppinsMedium14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),


        SizedBox(height: 10.h,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Date: ',
                      style: blackPoppinsRegularr12,),
                    Text( DateFormats.convertDate(controller.bookingList[index].date.toString(), DateFormats.yyyy_MM_dd, 'd MMMM yyyy'),
                      style: blackPoppinsSemiBold12,),
                  ],
                ),
                SizedBox(height: 5.h,),
                Text(controller.bookingList[index].time.toString(),
                  style: blackPoppinsRegularr12,)
              ],),
            GestureDetector(
              onTap: (){
                controller.checkPermissions(controller.bookingList[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: (controller.bookingList[index].valid_for_start.toString() == "1") ? Clr.searchHintColor : Clr.searchHintColor.withOpacity(0.42)
                ),
                padding: EdgeInsets.all(10),
                child: Text(AppText.start_session, style: TextStyle(
                    fontSize: 12.sp,
                    color: Clr.white,
                    fontFamily: Fonts.PoppinsMedium)),
              ),
            ),
          ],
        ),

      ],

    );
  }

}
