import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/colour.dart';

Widget instruction(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: instructionText(),
  );
}

TextStyle vendorStyle() {
  return  TextStyle(
      letterSpacing: 3,
      fontFamily: "PoppinsSemiBold",
      fontSize: 14.sp,
      color: Clr.venderFont);
}

TextStyle inputText() {
  return  TextStyle(
      fontSize: 14.sp, fontFamily: "PoppinsRegular", color: Clr.C_000000);
}

TextStyle instructionText() {
  return   TextStyle(
      fontSize: 14.sp,
      color: Clr.C_000000,
      fontFamily: "PoppinsLight");
}

TextStyle headLine() {
  return  TextStyle(
      fontSize: 14.sp,
      fontFamily: "PoppinsMedium",
      color: Clr.C_126DFF);
}

TextStyle headLine2() {
  return  TextStyle(
      fontSize: 13.sp, fontFamily: "PoppinsRegular", color: Clr.C_9B9B9B);
}

TextStyle appbarTitleTextStyle() {
  return const TextStyle(
      fontSize: 17, fontFamily: "PoppinsMedium", color: Clr.C_000000);
}

UnderlineInputBorder inputBorder2() {
  return const UnderlineInputBorder(
    borderSide: BorderSide(
      color: Clr.C_9B9B9B,
    ),
  );
}


TextStyle hintText() {
  return const TextStyle(
      fontSize: 14,
      fontFamily: "PoppinsLight",
      color: Clr.C_696969);
}

TextStyle buttonTextStyle() {
  return const TextStyle(
      fontSize: 16, fontFamily: "PoppinsMedium", color: Clr.C_ffffff);
}