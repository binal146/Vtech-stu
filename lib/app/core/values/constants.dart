import '../../../flavors/build_config.dart';

abstract class Constants {

  static const String  SUCCESS_CODE ="000";
  static const String  rupee_symobol ="₹";
  static const String  currency ="\$";

  static String  languages ="";

  static bool  isNotNow = false;
  static bool  isLanguageChange = false;


  static  bool  fromMenu = false;
  static  int  currentTab = -1;

   static  bool isProduction = BuildConfig.instance.config.isProduction;

   static String notification_sound = "default_sound";
  // static String notification_sound = "sound3";


}