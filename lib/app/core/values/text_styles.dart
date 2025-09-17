import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colour.dart';
import '../utils/fonts.dart';

Widget instruction(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: instructionText(),
  );
}

TextStyle instructionText() {
  return   TextStyle(
      fontSize: 14.sp,
      color: Clr.C_000000,
      fontFamily: "PoppinsLight");
}

TextStyle blackPoppinsSemiBold14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsSemiBold);

TextStyle blackPoppinsSemiBold13 = TextStyle(
    fontSize: 13.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsSemiBold);

TextStyle blackPoppinsSemiBold16 = TextStyle(
    fontSize: 16.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsSemiBold);

TextStyle blackPoppinsSemiBold12 = TextStyle(
    fontSize: 12.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsSemiBold);

TextStyle blackPoppinsRegular14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsMedium);



TextStyle blackPoppinsMedium14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsMedium);

TextStyle blackPoppinsMediumm18 = TextStyle(
    fontSize: 18.sp,
    color: Clr.black,
    fontFamily: Fonts.PoppinsMedium);



TextStyle blackPoppinsRegularr14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsRegular);

TextStyle blackPoppinsRegularr10 = TextStyle(
    fontSize: 10.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsRegular);

TextStyle blackPoppinsRegular13 = TextStyle(
    fontSize: 13.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsRegular);

TextStyle blackPoppinsRegular12 = TextStyle(
    fontSize: 12.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsMedium);

TextStyle blackPoppinsRegularr12 = TextStyle(
    fontSize: 12.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsRegular);

TextStyle blackPoppinsRegular212 = TextStyle(
    fontSize: 12.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsRegular);

TextStyle blackPoppinsLight12 = TextStyle(
    fontSize: 12.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsLight);

TextStyle blackPoppinsRegular10 = TextStyle(
    fontSize: 10.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsRegular);

TextStyle greyPoppinsRegular12 = TextStyle(
    fontSize: 12.sp,
    color: Clr.searchHintColor,
    fontFamily: Fonts.PoppinsRegular);

TextStyle bluePoppinsRegular14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.searchHintColor,
    fontFamily: Fonts.PoppinsRegular);

TextStyle searchHintPoppinLight12 = TextStyle(
    fontSize: 12.sp,
    color: Clr.searchHintColor,
    fontFamily: Fonts.PoppinsLight);

TextStyle greyPoppinsRegular10 = TextStyle(
    fontSize: 10.sp,
    color: Clr.greyTextDark,
    fontFamily: Fonts.PoppinsRegular);


TextStyle greyPoppinsRegular13 = TextStyle(
    fontSize: 13.sp,
    color: Clr.greyTextDark,
    fontFamily: Fonts.PoppinsRegular);

TextStyle grey919191PoppinsRegular14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.greyTextDark,
    fontFamily: Fonts.PoppinsRegular);

TextStyle greyPoppinsLight14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.greyColor,
    fontFamily: Fonts.PoppinsLight);

TextStyle greyPoppinsLight12 = TextStyle(
    fontSize: 14.sp,
    color: Clr.greyColor,
    fontFamily: Fonts.PoppinsLight);

TextStyle greyPoppinsRegular14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.greyColor,
    fontFamily: Fonts.PoppinsLight);


TextStyle blackPoppinsSemiBold18 = TextStyle(
    fontSize: 18.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsSemiBold);

TextStyle blackPoppinsSemiBold20 = TextStyle(
    fontSize: 20.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsSemiBold);

TextStyle blackPoppinsRegular16 = TextStyle(
    fontSize: 16.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsMedium);

TextStyle blackPoppinsSemibold16 = TextStyle(
    fontSize: 16.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsSemiBold);

TextStyle blackPoppinsMedium27 = TextStyle(
    fontSize: 27.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsMedium);

TextStyle blackPoppinsMedium17 = TextStyle(
    fontSize: 17.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsMedium);

TextStyle blackPoppinsMedium16 = TextStyle(
    fontSize: 16.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsMedium);

TextStyle blackPoppinsMedium12 = TextStyle(
    fontSize: 12.sp,
    color: Clr.searchHintColor,
    fontFamily: Fonts.PoppinsMedium);

TextStyle blackPoppinsMedium18 = TextStyle(
    fontSize: 16.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsMedium);

TextStyle blackPoppinsRegular18 = TextStyle(
    fontSize: 18.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsRegular);

TextStyle greyPoppinsRegular16 = TextStyle(
    fontSize: 16.sp,
    color: Clr.greyTextDark,
    fontFamily: Fonts.PoppinsRegular);

TextStyle greyPoppinsSemiBold16 = TextStyle(
    fontSize: 16.sp,
    color: Clr.greyTextDark,
    fontFamily: Fonts.PoppinsSemiBold);

TextStyle greyPoppinsSemiBold12 = TextStyle(
    fontSize: 12.sp,
    color: Clr.greyTextDark,
    fontFamily: Fonts.PoppinsSemiBold);


TextStyle blackPoppinsBold14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsBold);

TextStyle greyPoppinsBold14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.greyTextDark,
    fontFamily: Fonts.PoppinsBold);

TextStyle greyPoppinsMedium14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.greyTextDark,
    fontFamily: Fonts.PoppinsMedium);

TextStyle blackPoppinsSemiBold15 = TextStyle(
    fontSize: 15.sp,
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsSemiBold);

TextStyle whitePoppinsRegular14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.white,
    fontFamily: Fonts.PoppinsRegular);


final TextStyle unselectedLabelStyle = TextStyle(
    color: Clr.greyTextDark,
    fontFamily: Fonts.PoppinsSemiBold,
    fontSize: 12.sp);

TextStyle selectedLabelStyle = TextStyle(
    color: Clr.blackColor,
    fontFamily: Fonts.PoppinsSemiBold,
    fontSize: 12.sp);

TextStyle bluePoppinsRegular = TextStyle(
  fontSize: 14.sp,
  fontFamily: Fonts.PoppinsRegular,
  color: Clr.appColor,
);




/*new open sans font styles*/


/* New Styles */


TextStyle appBarTitle = TextStyle(
    fontSize: 18.sp,
    fontFamily: Fonts.PoppinsSemiBold,
    color: Clr.blackColor);

TextStyle subTitle = TextStyle(
    fontSize: 14.sp,
    fontFamily: Fonts.PoppinsRegular,
    color: Clr.blackColor);

TextStyle PoppinsRegular14 = TextStyle(
    fontSize: 14.sp,
    color: Clr.black,
    fontFamily: Fonts.PoppinsRegular
);



