import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/core/values/comman_text.dart';
import '../../core/utils/DateFormat.dart';
import '../../core/utils/colour.dart';
import '../../core/values/text_styles.dart';
import '/app/core/base/base_view.dart';
import 'call_detail_controller.dart';

class CallDetailView extends BaseView<CallDetailController> {

  final ScrollController _scrollController = ScrollController();

  late Map<String, dynamic> data;

  CallDetailView({super.key}) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !controller.isLoading.value &&
          controller.hasMoreData.value) {
        // Load next page when the user scrolls to the bottom
        controller.callGetBookingCallHistoryService(offset: controller.callDetailList.length);
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
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: Column(
        children: [
          Container(height: 40.h,
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
              Text(AppText.call_detail.toUpperCase(),
                style: appBarTitle,
                textAlign: TextAlign.center,
              )
            ],),),
          Expanded(child: RefreshIndicator(
            onRefresh: () async {
              controller.hasMoreData = true.obs;
              controller.currentPage = 1;
              controller.isLoading.value = false;
              controller.callGetBookingCallHistoryService();
            },
              child: Obx(() => (controller.callDetailList.isNotEmpty) ? ListView.builder(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
            itemCount: controller.callDetailList.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.callDetailList.length) {
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
                  child: Row(
                    children: [
                      // call_type (outgoing, incoming, misscall, declined)
                      (controller.callDetailList[index].call_type == "outgoing") ? Icon(Icons.call_made,) :
                      (controller.callDetailList[index].call_type == "incoming") ? Icon(Icons.call_received,) :
                      (controller.callDetailList[index].call_type == "misscall") ? Icon(Icons.call_missed,color: Colors.red,) :
                      Icon(Icons.call_missed,),

                      SizedBox(width: 5.w,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.callDetailList[index].call_type_title.toString(),style: blackPoppinsMedium14,),
                          SizedBox(height: 5.h,),
                          Text(DateFormats.convertDate(controller.callDetailList[index].start_time.toString(),
                              "yyyy-MM-dd hh:mm:ss",
                              "dd/MM/yy hh:mm a"),style: greyPoppinsRegular12,),
                        ],
                      ),

                      Flexible(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(controller.callDetailList[index].second.toString(),style: blackPoppinsMedium12,)),
                      ),

                    ],
                  ),
                ),
              );
            },) :  Obx(() => (controller.emptyMessage.value.isNotEmpty) ?  GestureDetector(
            onTap: (){
              controller.hasMoreData = true.obs;
              controller.currentPage = 1;
              controller.isLoading.value = false;
              controller.callGetBookingCallHistoryService();
            },
            child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Icon(Icons.refresh,size: 24.sp,),

                SizedBox(height: 10.h,),

                Text(controller.emptyMessage.value,style: blackPoppinsMedium14,),
              ],
            )),
          ) : SizedBox(),))),)
        ],
      ),
    );
  }


}
