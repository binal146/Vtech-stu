import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colour.dart';
import '../utils/fonts.dart';


class GreenButtonWidget extends StatelessWidget {

  final String text;
  final Function()? onClicked;

  const   GreenButtonWidget({
     Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onClicked,
    child: Container(
      alignment: Alignment.center,
      padding:  const EdgeInsets.symmetric(vertical: 0,horizontal: 16),
      height: MediaQuery.of(context).size.height/15,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color:Clr.greenButtonClr,
      ),
      child: Text(
        text,
        textScaleFactor: 1,
        style: TextStyle(
          fontSize: 16.sp,
          color: Clr.C_ffffff,
          fontFamily: Fonts.PoppinsSemiBold,
        ),
      ),
    ),
  );
}