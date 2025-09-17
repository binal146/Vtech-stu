import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colour.dart';
import 'fonts.dart';

class ButtonWidget extends StatelessWidget {

  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
     Key? key,
     required this.text,
     required this.onClicked,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onClicked,
        child: Container(
          alignment: Alignment.center,
          height: 45.w,
          width: double.infinity,
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Clr.addCart,
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
