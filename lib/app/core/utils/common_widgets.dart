import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/widgets/common_text_style.dart';
import '../../modules/widgets/fonts.dart';
import '../values/sharePrefrenceConst.dart';
import 'colour.dart';
import 'image.dart';
import 'locale_keys.g.dart';

// signalton functionality
class CommonUtils {
  static CommonUtils? commonUtils;

  static CommonUtils getIntance() {
    commonUtils ??= CommonUtils();
    return commonUtils!;
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Clr.primaryColor,
      textColor: Colors.white,
      timeInSecForIosWeb: 5,
    );
  }





  Widget customStatusBarMargin() {
    return Container(
      height: ScreenUtil().statusBarHeight,
      decoration: const BoxDecoration(color: Clr.C_ffffff),
    );
  }

  Widget customAppBar(BuildContext context, String title, bool isNoBack) {
    return Container(
      width: ScreenUtil().screenWidth,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: const BoxDecoration(color: Clr.C_ffffff),
      child: Stack(
        children: [
          isNoBack
              ? InkWell(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Drawables.icBack)
              : Container(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 4.h, 0, 0),
            child: Center(
              child: Text(
                title,
                textScaleFactor: 1,
                style: TextStyle(
                    color: Clr.C_000000,
                    fontSize: 17.sp,
                    fontFamily: Fonts.poppinsMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration buttonDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
      color: Clr.C_005ff9,
    );
  }

  TextStyle buttonTextStyle() {
    return  TextStyle(
        fontSize: 16.sp, fontFamily: "PoppinsMedium", color: Clr.C_ffffff);
  }

  TextStyle titleText() {
    return  TextStyle(
        color: const Color(0xFF000000), fontSize: 17.sp, fontFamily: "PoppinsMedium");
  }

  showAlertWithMultipleAction(BuildContext context, String message,
      Function() onPressedOK, Function() onPressedCancel) {
    showDialog(
        builder: (ctx) => AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
                child: const Text(LocaleKeys.yes),
                onPressed: () {
                  Navigator.pop(ctx);
                  onPressedOK();
                }),
            TextButton(
                child: const Text(LocaleKeys.cancel),
                onPressed: () {
                  Navigator.pop(ctx);
                  onPressedCancel();
                }),
          ],
        ),
        context: context);
  }

  Widget commonListTile(BuildContext context, String clk, leadingImg, String title) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(clk);
      },
      leading: leadingImg,
      title: Transform.translate(
        offset: const Offset(-20, 0),
        child: Text(title, textScaleFactor: 1, style: inputText()),
      ),
      trailing: SvgPicture.asset(Drawables.forwardArrow),
    );
  }

  Widget homeGrideContainer(String Count,String Title){
    return Container(
      height: 70.w,
      padding: EdgeInsets.only(left:8.w, right: 8.w),
      margin: EdgeInsets.only(right: 10.w, left: 10.w, bottom: 10.w),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Clr.C_ebeefb,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            Text(
              Count,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1,
              style: TextStyle(fontFamily: "PoppinsSemiBold", fontSize: 17.sp, color: Clr.C_000000),
            ),
            Text(
              Title,
              textScaleFactor: 1,
              style: TextStyle(fontFamily: "PoppinsRegular", fontSize: 12.sp, color: Clr.C_616161),
            ),
            Expanded(child: Container()),
          ]),
    );
  }

  Widget FormFields(BuildContext context, String hint, String lable,int keyboardType,int inputAction,int maxlines,Controllers){

    return TextFormField(
      style:TextStyle(
        fontSize: 14.sp,
          fontFamily: "PoppinsRegular",
          color: Clr.C_000000),

      minLines: 1,
      maxLines: maxlines,
      controller: Controllers,
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: inputBorder(),
        focusedBorder: inputBorder(),
        labelText: lable,
        labelStyle: hintText(),
        hintText: hint,
        hintStyle: hintText(),
      ),
      keyboardType: keyboardTypes(keyboardType),
      textInputAction: keyboardActions(inputAction),
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

  progressDialogue(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: alert);
      },
    );
  }

  Widget getInputTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: headLine(),
      ),
    );
  }

  Widget getInputTitle2(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: headLine2(),
      ),
    );
  }

  UnderlineInputBorder inputBorder() {
    return const UnderlineInputBorder(
        borderSide: BorderSide(color: Clr.C_9B9B9B));
  }

  TextStyle hintText() {
    return  TextStyle(
        fontSize: 14.sp, fontFamily: Fonts.poppinsRegular, color: Clr.C_000000);
  }

  hidekeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<List<String>> getDeviceData() async {
    var deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    List<String> data = [];
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      data.add(iosDeviceInfo.identifierForVendor!);
      data.add(iosDeviceInfo.model);
      data.add(iosDeviceInfo.utsname.version.toString());
      data.add(packageInfo.buildNumber);
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      if (androidDeviceInfo.id != null) {
        data.add(androidDeviceInfo.id);
      } else {
        data.add(androidDeviceInfo.id);
      }
      data.add(androidDeviceInfo.model);
      data.add(androidDeviceInfo.version.sdkInt.toString());
      data.add(packageInfo.version);

      data.add(packageInfo.buildNumber);
    }
    return data;
  }
}
