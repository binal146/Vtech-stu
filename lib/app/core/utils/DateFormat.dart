import 'package:intl/intl.dart';

class DateFormats{

  static String dd_MM_yyyy = 'dd-MM-yyyy';
  static String yyyy_MM_dd = 'yyyy-MM-dd';
  static String d_MMMM_yyyy = 'd MMMM, yyyy';
  static String yyyy_MM_dd_hh_mm_ss = 'yyyy-MM-dd hh:mm:ss';
  static String dd_MM_yy_hh_mm_a = 'dd/MM/yy hh:mm a';

  static String convertDate(String date,String inputDateFormat,String outputDateFormat) {
    DateTime parsedDate = DateFormat(inputDateFormat).parse(date);
    String formattedDate = DateFormat(outputDateFormat).format(parsedDate);
    return formattedDate;
  }

  static String convertDateTime(String date,String inputDateFormat,String outputDateFormat) {
    DateTime parsedDate = DateFormat(inputDateFormat).parse(date);
    String formattedDate = DateFormat(outputDateFormat).format(parsedDate);
    return formattedDate;
  }

  static String convertDate24(String date,String outputDateFormat) {
    DateTime dateTime = DateTime.parse(date); // Parse the string into DateTime

    // Convert to 12-hour format with AM/PM
    String time12 = DateFormat(outputDateFormat).format(dateTime);
    return time12;
  }
}
