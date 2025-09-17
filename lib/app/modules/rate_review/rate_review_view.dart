import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../core/widget/custom_app_bar.dart';
import '/app/core/base/base_view.dart';
import 'rate_review_controller.dart';

class RateReviewView extends BaseView<RateReviewController> {

  bool isAddtoCart = false;

  RateReviewView({super.key});

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
            Text(AppText.rate_reviews,
              style: appBarTitle,
              textAlign: TextAlign.center,
            )
          ],),),
        SingleChildScrollView(
          child: Container(
            color: Clr.white,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(
                  height: 40.h,
                ),

                    RatingBar(
                      initialRating: 3,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
            full: SvgPicture.asset(Drawables.rate_enable),
            half: SvgPicture.asset(Drawables.radio_on),
            empty: SvgPicture.asset(Drawables.rate_disable),
                      ),
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (rating) {
            print(rating);
            controller.rating.value = rating;
                      },
                    ),

                SizedBox(
                  height: 10.h,
                ),

                Text(controller.rating.value.toString(),style: TextStyle(
                    fontSize: 24.sp, fontFamily: Fonts.PoppinsRegular, color: Clr.searchHintColor),),

                SizedBox(
                  height: 20.h,
                ),

                TextField(
                  maxLines: 5,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
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
                      hintStyle: hintText(),
                      hintText: AppText.write_review_here
                  ),
                ),

              ],),
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
          // controller.signUpService();
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

}
