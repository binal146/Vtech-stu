import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colour.dart';
import '../utils/fonts.dart';

class CommanTextField extends StatelessWidget {

  final String hint;
  final String label;
  final int keyboardType;
  final int inputAction;
  final int maxlines;
  final bool isPassword;
  final bool isBottomLine;
  final bool isEnable;
  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final bool isOnlyCharAllow;
  final TextEditingController? controller;

   const CommanTextField({super.key, 
     required this.hint,
     required this.label,
     required this.keyboardType,
     required this.inputAction,
     required this.maxlines,
     this.prefixIcon,
     this.sufixIcon,
     this.isPassword = false,
     this.isBottomLine = true,
     this.isEnable = true,
     this.isOnlyCharAllow = false,
     required this.controller,
   });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style:TextStyle(
            fontSize: 14.sp,
            fontFamily: Fonts.PoppinsRegular,
            color: Clr.black),
        minLines: 1,
        maxLines: maxlines,
        obscureText: isPassword,
        controller: controller,
        autofocus: false,
        enabled: isEnable,
        decoration: InputDecoration(
          labelText: label, // Label i
            contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 20), // nside the TextField
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color:  Clr.redColor, // Change border color on focus
              width: 0.5,
            ),
          ),
            isDense: false,
          suffixIcon:Padding(padding: EdgeInsets.only(right:10),
          child: sufixIcon,),
            suffixIconConstraints: BoxConstraints(
                minHeight: 28.h,
                minWidth: 28.w,
            ),
            prefixIcon:prefixIcon,
            prefixIconConstraints: BoxConstraints(
              minHeight: 28.h,
              minWidth: 28.w,
            ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color:  Clr.borderColor, // Change border color on focus
              width: 0.5,
            ),
          ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: BorderSide(
                color:  Clr.borderColor, // Change border color on focus
                width: 0.5,
              ),
            ),
          labelStyle: hintText(),
          hintStyle: labelText()
        ),
        inputFormatters: (isOnlyCharAllow == true) ? [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
        ] : (keyboardType == 2) ? [
          FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces
        ] : [],

      /*      decoration: InputDecoration(
          isDense: true,
          enabledBorder: (isBottomLine) ? inputBorder() : InputBorder.none,
          focusedBorder: (isBottomLine) ? inputBorder() : InputBorder.none,
          labelText: label,
          labelStyle: hintText(),
          hintText: hint,
          hintStyle: hintText(),
          prefixIcon: prefixIcon,
          suffixIcon:sufixIcon,
        ),*/
        keyboardType: keyboardTypes(keyboardType),
        textInputAction: keyboardActions(inputAction),
      ),
    );
  }

  TextInputType keyboardTypes(int value) {
    switch (value) {
      case 1:
        return TextInputType.emailAddress;
      case 2:
        return TextInputType.visiblePassword;
      case 3:
        return TextInputType.number;
      case 4:
        return TextInputType.name;
      case 5:
        return TextInputType.text;
      case 6:
        return TextInputType.url;
      case 7:
        return TextInputType.datetime;
      case 8:
        return TextInputType.multiline;
      case 9:
        return TextInputType.streetAddress;
      case 10:
        return TextInputType.none;
      case 11:
        return TextInputType.phone;
      default:
        return TextInputType.none;
    }
  }

  TextInputAction keyboardActions(int value) {
    switch (value) {
      case 1:
        return TextInputAction.next;
      case 2:
        return TextInputAction.done;
      case 3:
        return TextInputAction.previous;
      case 4:
        return TextInputAction.search;
      case 5:
        return TextInputAction.go;
      case 6:
        return TextInputAction.send;
      case 7:
        return TextInputAction.newline;
      case 8:
        return TextInputAction.join;
      case 9:
        return TextInputAction.continueAction;
      case 10:
        return TextInputAction.emergencyCall;
      case 11:
        return TextInputAction.none;
      default:
        return TextInputAction.none;
    }
  }


  InputDecoration inputDecoration(BuildContext context, String hint, String lable) {
    return InputDecoration(
      enabledBorder: inputBorder(),
      focusedBorder: inputBorder(),
      labelText: lable,
      labelStyle: hintText(),
      hintText: hint,
      hintStyle: hintText(),
    );
  }

  OutlineInputBorder inputBorder() {
    return  OutlineInputBorder(
        borderSide: BorderSide(color: Clr.greyText));
  }
  

  TextStyle hintText() {
    return  TextStyle(
        fontSize: 14.sp, fontFamily: Fonts.PoppinsRegular, color: Clr.colorBFBFBF);
  }

  TextStyle labelText() {
    return  TextStyle(
        fontSize: 12.sp, fontFamily: Fonts.PoppinsRegular, color: Clr.colorBFBFBF);
  }


}
