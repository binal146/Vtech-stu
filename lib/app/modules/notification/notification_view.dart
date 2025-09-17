import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/core/utils/DateFormat.dart';
import 'package:vteach_teacher/app/modules/notification/notification_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';

class NotificationView extends BaseView<NotificationController> {
  final ScrollController _scrollController = ScrollController();

  NotificationView({super.key}) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !controller.isLoading.value &&
          controller.hasMoreData.value) {
        // Load next page when the user scrolls to the bottom
        controller.callGetNotificationListService(offset: controller.notificationList.length);
      }
    });
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        Get.back(result: true);
      },
      child: RefreshIndicator(
        onRefresh: () async {
           controller.hasMoreData = true.obs;
           controller.currentPage = 1;
           controller.isLoading.value = false;
          controller.callGetNotificationListService(offset: 0); // Refresh from the first page
        },
        child: Column(
          children: [
            Container(
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back(result: true);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Clr.backButtonBg,
                      ),
                      child: Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    AppText.notifications.toUpperCase(),
                    style: appBarTitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Obx(() {
                  if (controller.notificationList.isNotEmpty) {
                    return ListView.builder(
                      controller: _scrollController, // Attach ScrollController for pagination
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: controller.notificationList.length + 1, // Extra item for loading indicator
                      itemBuilder: (context, index) {
                        if (index == controller.notificationList.length) {
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

                        // Your notification item UI
                        return InkWell(
                          onTap: () {
                            if (controller.notificationList[index].notificationType == "booking_by_student") {

                              if (controller.notificationList[index].bookingStatus == "pending"){
                                Get.toNamed(Routes.REQUEST_APPOINTMENT_DETAIL, arguments: controller.notificationList[index].bookingId.toString(),parameters: {'fromNotification':"1"});
                              } else {
                                Get.toNamed(Routes.APPOINTMENT_DETAIL, parameters: {
                                  'type': '1',
                                  'bookingId': controller.notificationList[index].bookingId.toString(),
                                  'bookingSlotId': controller.notificationList[index].bookingSlotId.toString(),
                                  'open_call_history' : "0"
                                });
                              }
                            }else if (controller.notificationList[index].notificationType == "profile_approve"){

                            } else {
                              Get.toNamed(Routes.APPOINTMENT_DETAIL, parameters: {
                                'type': '1',
                                'bookingId': controller.notificationList[index].bookingId.toString(),
                                'bookingSlotId': controller.notificationList[index].bookingSlotId.toString(),
                                'open_call_history' : "0"
                              });
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              Text(
                                controller.notificationList[index].title.toString(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Clr.black,
                                  fontFamily: Fonts.PoppinsMedium,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                controller.notificationList[index].message.toString(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Clr.darkGrey,
                                  fontFamily: Fonts.PoppinsRegular,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                DateFormats.convertDate(
                                    controller.notificationList[index].createdAt.toString(),
                                    "yyyy-MM-dd HH:mm:ss",
                                    "dd MMM yyyy hh:mm a"),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Clr.colora7a7a7,
                                  fontFamily: Fonts.PoppinsRegular,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Divider(color: Clr.grey_bg, height: 1, thickness: 1),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (controller.isLoading.value && controller.notificationList.isEmpty) {
                    return SizedBox();
                  } else {
                    // Show no data message and refresh option
                    return GestureDetector(
                      onTap: () {
                        controller.hasMoreData = true.obs;
                        controller.currentPage = 1;
                        controller.isLoading.value = false;
                        controller.callGetNotificationListService(offset: 0);
                      },
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, size: 24.sp),
                            SizedBox(height: 10.h),
                            Text(controller.noDataMessage.value, style: blackPoppinsMedium14),
                          ],
                        ),
                      ),
                    );
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

