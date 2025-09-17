import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Variables
var selectedIndex = 0;
double screenWidth = 0.0;
double screenHeight = 0.0;
double size = 0.0;
late bool isTablet;
//var appCurrency = "₹ ";
var appCurrency = " ";
var glbStoreId = "";
var glbStoreName = "";
var glbMobileNo = "";
var glbEmail = "";
var glbLat = "";
var glbLong = "";
var glbIsOnline = "";
var glbUniqueURL = "";
var glbStoreImage = "";
var glbQrCode = "";
var address = "";
var addressLine1 = "";
var addressLine2 = "";
var country_code = "";
var selectedNavCatID = "";
var selectedNavSubCatID = "";
var selectedNavCatName = "";
var selectedNavSubCatName = "";
var baseUrlQrCode = "";
var userType = "";
var currentPlanId = "";
var countryId = "";
var stateId = "";
var cityID = "";
var zoneId = "";
var versionCode = "";
var isLoadingHome = true;
var isLoadingMenu = true;
var isCallBack = false;
var isCallBackUpdateCategory = false;
int? offset;
int? offsetProduct;

int? qrCode = 0;
int? deliverySettings = 0;
int? taxSettings = 0;
int? orderSettings = 0;
int? paymentSettings = 0;
int? domainSettings = 0;
int? manageOutlets = 0;
int? menuManagement = 0;
int? coupons = 0;
int? managers = 0;
int? manageWaiters = 0;
int? manageDeliveryBoys = 0;
int? myCustomers = 0;
int? manageTables = 0;
int? restaurantTimeSettings = 0;
int? supportSettings = 0;
int? smtpSettings = 0;
int? customsAppNotifications = 0;
int? addOns = 0;
int? takeOrders = 0;
int? loyalty = 0;
int? notificationSettings = 0;
int? languageSettings = 0;
int? inventory = 0;
int? integration = 0;
int? preOrderSettings = 0;
int? pinCodeBasedDeliverySettings = 0;
int? radiusBasedDeliverySettings = 0;
int? googleAnalytics = 0;
bool isDialogShowing = false;

String orderTypeAll = "all";


List<dynamic>? suggestions = [];
List<Widget> widgetOptions = <Widget>[];
List<BottomNavigationBarItem> navigationItems = <BottomNavigationBarItem>[];
final int maxSizeInBytes = 5 * 1024 * 1024; // 5 MB limit
// fonts
var regular = "Montserrat";
var dateFormatDDMMYYYY = "dd-MMM-yyyy, hh:mm a";
var dateFormatYYYYMMDDHHMM = "yyyy-MM-dd HH:mm:ss";
// colors
//var appColor = Color.fromRGBO(251, 97, 7, 1);
var appColor = const Color(0xFFFb6107);
var appColorLight = Color.fromRGBO(255, 132, 57, 1.0);
var appColorDisable = Color.fromRGBO(255, 132, 57, 0.5764705882352941);
Color app187_187_187 = Color.fromARGB(255, 187, 187, 187);
var appGreen = Color.fromRGBO(40, 180, 92, 1);

double getResponsiveWidth(double width) {
  double scaleFactor =  screenWidth /423.5293998850261;
  return isTablet?width * scaleFactor:width;
}

double getResponsiveHeight(double height) {
  double scaleFactor =  screenHeight / 897.0587983675902;
  return isTablet ?height * scaleFactor:height;
}

double getResponsiveFontSize(double fontSize) {
  double baseFontSize = 423.5293998850261; // Base width for phones
  double scaleFactor =  screenWidth / baseFontSize;
  /*print("original"+fontSize.toString());
  print("fontSize * scaleFactor"+(fontSize * scaleFactor).toString());*/
  return isTablet?((fontSize * scaleFactor)-4):fontSize;
}

double getResponsiveMargin(double margin) {
  double baseMargin = 423.5293998850261; // Base width for phones
  double scaleFactor =  screenWidth / baseMargin;
  return isTablet?margin * scaleFactor:margin;
}

double getResponsivePadding(double padding) {
  double baseMargin = 423.5293998850261; // Base width for phones
  double scaleFactor =  screenWidth / baseMargin;
  return isTablet?padding * scaleFactor:padding;
}

double getResponsiveRadius(double radius) {
  double baseMargin = 423.5293998850261; // Base width for phones
  double scaleFactor =  screenWidth / baseMargin;
  return isTablet?radius * scaleFactor:radius;
}

String getPlatform() {
  if (Platform.isAndroid) {
    return "android";
  } else if (Platform.isIOS) {
    return "ios";
  } else {
    return "other";
  }
}

Future<String> getAppVersionCode() async {
  // Fetch package information
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // Get the version code (build number)
  String versionCode = packageInfo.buildNumber;
  // Return the version code
  return versionCode;
}


void playSound() async {
  /*AudioPlayerManager.instance.stop();
  AudioPlayerManager.instance.play('audio/bell_ring.mp3');*/
}

void stopSound() {
  //AudioPlayerManager.instance.stop();
}




clearAll() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("store_id");
  prefs.clear();

  selectedIndex = 0;
  appCurrency = " ";
  glbStoreId = "";
  glbStoreName = "";
  glbMobileNo = "";
  glbEmail = "";
  glbLat = "";
  glbLong = "";
  glbIsOnline = "";
  glbUniqueURL = "";
  glbStoreImage = "";
  glbQrCode = "";
  address = "";
  country_code = "";
  selectedNavCatID = "";
  selectedNavCatName = "";
  baseUrlQrCode = "";
  isLoadingHome = true;
  isLoadingMenu = true;
  offset;
  offsetProduct;
}

// Custom functions
showToast(BuildContext context, String text) {
  /*  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: 100.0),
    content: Text(
      text,
      textAlign: TextAlign.center,
    ),
  ));*/
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
  );
}



void formatEmailTrim(String value, TextEditingController textEditingController) {
  String str = value.toString();
  if (str.isNotEmpty && str.contains(" ")) {
    textEditingController.text = textEditingController.text.replaceAll(" ", "");
    textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
  }
}

String convertDateFormat(dateTimeString, String oldFormat, String newFormat) {
  /// Convert into local date format.
  var localDate = DateTime.parse(dateTimeString).toLocal();
  var inputFormat = DateFormat(oldFormat);
  var inputDate = inputFormat.parse(localDate.toString());
  /// outputFormat - convert into format you want to show.
  var outputFormat = DateFormat(newFormat);
  var outputDate = outputFormat.format(inputDate);
  return outputDate.toString();
}

Future<List<String?>> getDeviceData() async {
  var deviceInfo = DeviceInfoPlugin();
  PackageInfo? packageInfo = await PackageInfo.fromPlatform();
  List<String?> data = [];
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    data.add(iosDeviceInfo.identifierForVendor);
    data.add(iosDeviceInfo.model);
    data.add(iosDeviceInfo.utsname.version.toString());
    data.add(packageInfo.buildNumber);
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    data.add(androidDeviceInfo.id);
    data.add(androidDeviceInfo.model);
    data.add(androidDeviceInfo.version.sdkInt.toString());
    data.add(packageInfo.version);
    data.add(packageInfo.buildNumber);
  }
  return data;
}

bool checkGreaterThenCompare(String textPrice, String textStrikeMrp) {
  bool isChecked = false;
  if (double.parse(textStrikeMrp) > double.parse(textPrice)) {
    isChecked = true;
  } else {
    isChecked = false;
  }
  return isChecked;
}
