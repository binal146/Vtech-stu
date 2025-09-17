import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/core/utils/DateFormat.dart';
import 'package:vteach_teacher/app/modules/review_list/review_controller.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '/app/core/base/base_view.dart';

class ReviewView extends BaseView<ReviewController> {

  ReviewView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.callGetReviewListService();
      },
      child: Column(children: [
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
            Text(AppText.reviews.toUpperCase()+' (${controller.totalReview})',
              style: appBarTitle,
              textAlign: TextAlign.center,
            )
          ],),),
    /*    SizedBox(height: 10.h,),
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar(
              initialRating: double.parse(controller.rating.value),
              direction: Axis.horizontal,
              allowHalfRating: false,
              ignoreGestures: true,
              itemCount: 5,
              ratingWidget: RatingWidget(
                full: Padding(
                    padding: EdgeInsets.all(5),
                    child: SvgPicture.asset(Drawables.rate_enable)),
                half: SvgPicture.asset(Drawables.radio_on),
                empty: Padding(
                    padding: EdgeInsets.all(5),
                    child: SvgPicture.asset(Drawables.rate_disable)),
              ),
              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
              onRatingUpdate: (rating) {
              },
            ),
            SizedBox(width: 5.w,),
            Text(controller.rating.value.toString(),style: TextStyle(
                fontSize: 16.sp,
                color: Clr.black,
                fontFamily: Fonts.PoppinsMedium),)
          ],
        ),),
        SizedBox(height: 20.h,),*/
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Obx(() => (controller.reviewList.isNotEmpty)? ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.reviewList.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h,),

                    Row(
                      children: [

                        SizedBox(
                            height: 50.sp,
                            width: 50.sp,
                            //square box; equal height and width so that it won't look like oval
                            child: (controller.reviewList[index].student_profile == null || controller.reviewList[index].student_profile!.isEmpty) ? ClipOval(
                                child: Image.asset(Drawables.placeholder_photo,fit: BoxFit.cover,)) : ClipOval(
                                child: Image.network(controller.reviewList[index].student_profile.toString(),fit: BoxFit.cover,))),

                        SizedBox(width: 5.w,),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.reviewList[index].student_name.toString(), style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Clr.black,
                                  fontFamily: Fonts.PoppinsMedium),),

                            ],
                          ),
                        ),

                        SizedBox(width: 10.w,),

                        SvgPicture.asset(Drawables.star,height: 16,width: 16,),

                        SizedBox(width: 2.w,),

                        Text(controller.reviewList[index].rating.toString(), style: TextStyle(
                            fontSize: 14.sp,
                            color: Clr.greyColor,
                            fontFamily: Fonts.PoppinsMedium),
                        )

                      ],
                    ),

                    SizedBox(height: 5.h,),


                    Text(controller.reviewList[index].review.toString(),style: TextStyle(
                        fontSize: 14.sp,
                        color: Clr.greyColor,
                        fontFamily: Fonts.PoppinsRegular),),

                    SizedBox(height: 5.h,),

                    Text(DateFormats.convertDate(controller.reviewList[index].date.toString(), "yyyy-MM-dd HH:mm:ss", "dd MMM yyyy hh:mm a"),style: TextStyle(
                        fontSize: 11.sp,
                        color: Clr.colora7a7a7,
                        fontFamily: Fonts.PoppinsRegular),),


                    SizedBox(height: 10.h,),

                    Divider(color: Clr.grey_bg,height: 1,thickness: 1,),


                  ],
                );
              },) : GestureDetector(
              onTap: (){
                controller.callGetReviewListService();
              },
                child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Icon(Icons.refresh,size: 24.sp,),

                    SizedBox(height: 10.h,),

                    Text(controller.noDataMessage.value,style: blackPoppinsMedium14,),
                  ],
                )),
              ),),
          ) ,
        ),
      ],),
    );
  }

}
