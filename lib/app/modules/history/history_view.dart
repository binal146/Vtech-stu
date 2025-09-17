import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/core/utils/DateFormat.dart';
import 'package:vteach_teacher/app/core/values/comman_text.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/values/text_styles.dart';
import '/app/core/base/base_view.dart';
import 'history_controller.dart';
import 'model/Years.dart';

class HistoryView extends BaseView<HistoryController> {

  late Map<String, dynamic> data;
  final ScrollController _scrollController = ScrollController();

  List colors = [ const Color(0xFFfdf4e2),const Color(0xFFFEEBF7),const Color(0xFFE6FFFB),const Color(0xFFFEE7E3),];
  List colors2 = [ const Color(0xFFFBE8C6),const Color(0xFFFBD8EC),const Color(0xFFC8F6ED),const Color(0xFFFBD9D5),];

  HistoryView({super.key}) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !controller.isLoading.value &&
          controller.hasMoreData.value) {
        // Load next page when the user scrolls to the bottom
        controller.callTransactionHistoryService(offset: controller.monthList.length);
      }
    });
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.hasMoreData.value = true;
        controller.currentPage = 1;
        controller.isLoading.value = false;
        controller.callTransactionHistoryService(offset: 0); // Refresh from the first page
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [

            Container(height: 40.h,
              padding: EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(AppText.history,
                  style: appBarTitle,
                  textAlign: TextAlign.center,
                ),
              ),),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text(controller.selectedYear.value, style: blackPoppinsRegularr14),),
                    Theme(
                      data: Theme.of(context).copyWith(
                        popupMenuTheme: PopupMenuThemeData(
                          color: Colors.white, // Set background color to white
                        ),
                      ),
                      child: PopupMenuButton<Years>(
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 16.sp, // Set a smaller size here
                        ),
                        onSelected: (value) {
                          if (controller.selectedYear.value != value.year.toString()) {
                            controller.selectedYear.value = value.year.toString();
                            controller.hasMoreData = true.obs;
                            controller.currentPage = 1;
                            controller.isLoading.value = false;
                            controller.callTransactionHistoryService();
                          }
                        },
                        itemBuilder: (context) {
                          return controller.years.map((year) {
                            return PopupMenuItem<Years>(
                              value: year,
                              child: Text(year.year.toString(), style: blackPoppinsRegularr14),
                            );
                          }).toList();
                        },
                        offset: Offset(0, 50), // Adjust position to appear below the text
                      ),

                    ),
                  ],
                ),

                Obx(() => Text('\$'+controller.totalEarned.value.toString(),style: TextStyle(
                    fontSize: 18.sp,
                    color: Clr.blackColor,
                    fontFamily: Fonts.PoppinsSemiBold),),),
                SizedBox(height: 2.h,),
                Text(AppText.earned,style: blackPoppinsRegularr14,),
              ],
            ),

            SizedBox(height: 5.h,),

            Expanded(
              child: Obx(() {
                if (controller.monthList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: controller.monthList.length, // Parent list count (e.g., months)
                    itemBuilder: (context, parentIndex) {
                      // Parent List Item (e.g., Month header)
                      final parentItem = controller.monthList[parentIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              parentItem.monthName.toString(), // E.g., "May"
                              style: blackPoppinsSemiBold13,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          // Child ListView (transactions for this month)
                          ListView.builder(
                            controller: _scrollController, // Optional for pagination
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(), // Prevent nested scrolling
                            itemCount: parentItem.transactions?.length,
                            itemBuilder: (context, childIndex) {
                              final transaction = parentItem.transactions![childIndex];
                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey[200]!),
                                  color: Clr.viewBg,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ID: ${transaction.transactionId} ${DateFormats.convertDate24(transaction.transactionAt.toString(), "dd/MM/yy hh:mm a")}',
                                                style: blackPoppinsRegular212,
                                              ),
                                              Text(
                                                'BOOKING ID: ${transaction.bookingNumber}',
                                                style: blackPoppinsRegular212,
                                              ),
                                              Text(
                                                'APPOINTMENT ID: ${transaction.bookingSlotNumber}',
                                                style: blackPoppinsRegular212,
                                              ),
                                            ],
                                          ),
                                        ),

                                        Text(
                                          '${transaction.isRefund ? '-' : '+'}\$${transaction.amount}',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: transaction.isRefund
                                                ? Clr.colorf20000
                                                : Clr.greenColor,
                                            fontFamily: Fonts.PoppinsMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      '${AppText.session_date} ${DateFormats.convertDate(transaction.sessionDate.toString(), DateFormats.dd_MM_yyyy, 'd MMMM yyyy')}',
                                      style: blackPoppinsSemiBold13,
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      transaction.time.toString(),
                                      style: blackPoppinsRegularr12,
                                    ),
                                    SizedBox(height: 10.h),
                                    transaction.isRefund
                                        ? Text(
                                      AppText.refunded_cancelled_appointment,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Clr.colorf20000,
                                        fontFamily: Fonts.PoppinsRegular,
                                      ),
                                    )
                                        : SizedBox(),
                                    transaction.isRefund
                                        ? SizedBox(height: 10.h)
                                        : SizedBox(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          flex:1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Clr.green200,
                                            ),
                                            padding: EdgeInsets.all(7),
                                            margin: EdgeInsets.only(right: 10),
                                            child: Text(
                                              transaction.subjectTitle.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Clr.blackColor,
                                                fontFamily: Fonts.PoppinsRegular,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.w,),
                                        Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [

                                              SizedBox(
                                                  height: 30.sp,
                                                  width: 30.sp,
                                                  //square box; equal height and width so that it won't look like oval
                                                  child: (transaction.studentProfile != null && transaction.studentProfile.toString().isNotEmpty) ? ClipOval(child: Image.network(transaction.studentProfile.toString().toString(),fit: BoxFit.cover,)) : ClipOval(
                                                    child: Image.asset(
                                                      Drawables.placeholder_photo, fit: BoxFit.cover,),
                                                  )),
                                              SizedBox(width: 5.w),
                                              Flexible(
                                                child: Text(
                                                  transaction.studentName.toString(),
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
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (controller.isLoading.value &&
                    controller.monthList.isEmpty) {
                  return SizedBox();
                } else {
                  // Show no data message
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        controller.hasMoreData = true.obs;
                        controller.currentPage = 1;
                        controller.isLoading.value = false;
                        controller.callTransactionHistoryService(offset: 0);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, size: 24.sp),
                          SizedBox(height: 10.h),
                          Text(controller.noDataMessage.value,
                              style: blackPoppinsMedium14),
                        ],
                      ),
                    ),
                  );
                }
              }),
            )
            ,
          ],),
      ),
    );
  }
}
