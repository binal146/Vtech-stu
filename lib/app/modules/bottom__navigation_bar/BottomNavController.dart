import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:vteach_teacher/app/core/base/base_controller.dart';
import 'package:vteach_teacher/app/modules/appointment/appointment_binding.dart';
import 'package:vteach_teacher/app/modules/appointment/appointment_controller.dart';
import 'package:vteach_teacher/app/modules/appointment/appointment_view.dart';
import 'package:vteach_teacher/app/modules/history/history_binding.dart';
import 'package:vteach_teacher/app/modules/history/history_view.dart';
import 'package:vteach_teacher/app/modules/home/home_binding.dart';
import 'package:vteach_teacher/app/modules/home/home_view.dart';
import 'package:vteach_teacher/app/modules/more/more_binding.dart';
import 'package:vteach_teacher/app/modules/more/more_view.dart';
import '../../core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/sharePrefrenceConst.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../../routes/app_pages.dart';
import '../NotificationPayloadModel.dart';
import '../appointment_detail/appointment_detail_controller.dart';
import '../home/home_controller.dart';

class BottomNavController extends BaseController with WidgetsBindingObserver {
  final ProjectRepository _repository =
      Get.find(tag: (ProjectRepository).toString());

  var currentIndex = 0.obs;

  NotificationPayloadModel? notificationModel;

  late final Uuid _uuid;
  bool isFromNotification = false;
  RxBool isCallEndFromScreen = false.obs;

  String bookingId = "";
  String bookingSlotId = "";

  final pages = <String>[
    Routes.HOME,
    Routes.APPOINTMENT,
    Routes.HISTORY,
    Routes.MORE
  ];

  String _currentUuid = "";
  RxString textEvents = "".obs;

  late PageController pageController;

  late SharedPreferences sharedPreferences;

  static const _channel = MethodChannel('com.vTeachTeacher.device_token');
  static const _channel_Voip_Token =
      MethodChannel('com.vTeachTeacher.voip_token');
  static const _channel_Voip_Call =
      MethodChannel('com.vTeachTeacher.voip_call');
  String deviceTokenIOS = "";
  String voipTokenIOS = "";

  void changePage(int index) {
    print("RAJNIKANT ------>" + index.toString());
    if (currentIndex != index) {
      currentIndex.value = index;
      Get.offAndToNamed(
        pages[index],
        id: 1,
      );
    }
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == Routes.HOME) {
      return GetPageRoute(
        settings: settings,
        page: () => HomeView(),
        binding: HomeBinding(),
      );
    }

    if (settings.name == Routes.APPOINTMENT) {
      return GetPageRoute(
        settings: settings,
        page: () => AppointMentView(),
        binding: AppointmentBinding(),
      );
    }

    if (settings.name == Routes.HISTORY) {
      return GetPageRoute(
        settings: settings,
        page: () => HistoryView(),
        binding: HistoryBinding(),
      );
    }

    if (settings.name == Routes.MORE) {
      return GetPageRoute(
        settings: settings,
        page: () => MoreView(),
        binding: MoreBinding(),
      );
    }

    return null;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
    _uuid = const Uuid();
    // new code added
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool(SharePreferenceConst.fromNotification) !=
        null) {
      isFromNotification =
          sharedPreferences.getBool(SharePreferenceConst.fromNotification)!;
    }

    print("Open BottomNav screen");

    if (isFromNotification) {
      sharedPreferences.setBool(SharePreferenceConst.fromNotification, false)!;
      String? data = sharedPreferences
          .getString(SharePreferenceConst.notification_payload);
      //CommonUtils.getIntance().toastMessage(data!);
      var valueMap = convertPayloadNew(data.toString());
      NotificationPayloadModel notificationModel1 =
          NotificationPayloadModel.fromJson(valueMap);
      notificationModel = notificationModel1;
      sharedPreferences.setBool(SharePreferenceConst.fromNotification, false);
      if (notificationModel!.notification_type.toString() ==
          "vcall_by_student") {
        openCallScreen(notificationModel!.notification_type.toString());
      } else if (notificationModel!.notification_type.toString() ==
              "vcall_misscall_by_student" ||
          notificationModel!.notification_type.toString() == "vcall_timeout") {
        openCallHistoryScreen(
            notificationModel!.notification_type.toString(),
            notificationModel!.booking_id.toString(),
            notificationModel!.booking_slot_id.toString());
      } else if (notificationModel!.notification_type.toString() ==
          "booking_by_student") {
        var result = await Get.toNamed(Routes.REQUEST_APPOINTMENT_DETAIL,
            arguments: notificationModel!.booking_id.toString());
        if (result == true) {
          if (Get.isRegistered<HomeController>()) {
            final HomeController homeController =
                Get.put(HomeController(), permanent: false);
            homeController.callGetPendingBooking();
          }
        }
      } else if (notificationModel!.notification_type.toString() == "booking_auto_cancel" ||
          notificationModel!.notification_type.toString() == "booking_cancel_by_student" ||
          notificationModel!.notification_type.toString() == "booking_completed" ||
          notificationModel!.notification_type.toString() == "booking_auto_rejected" ||
          notificationModel!.notification_type.toString() == "save_rating") {
        Get.toNamed(Routes.APPOINTMENT_DETAIL, parameters: {
          'type': '1',
          'bookingId': notificationModel!.booking_id.toString(),
          'bookingSlotId': notificationModel!.booking_slot_id.toString(),
          'open_call_history': "0",
        });
      }
      sharedPreferences.setString('', "");
    } else {
      // CommonUtils.getIntance().toastMessage(" Not From notification");
    }

    if (Platform.isAndroid) {
      requestNotificationPermissions();
      requestPermissions();
    }

    if (Platform.isIOS) {
      _channel_Voip_Call.setMethodCallHandler((call) async {
        if (call.method == 'handleIncomingCall') {
          Get.toNamed(Routes.CALL);
        }
      });

      _channel.setMethodCallHandler((call) async {
        if (call.method == 'updateDeviceToken') {
          final String deviceToken = call.arguments;
          print('APNs Device Token From Dart FIle: $deviceToken');
          deviceTokenIOS = deviceToken;
          sharedPreferences.setString(
              SharePreferenceConst.apns_device_token, deviceToken);
        }
      });

      _channel_Voip_Token.setMethodCallHandler((call) async {
        if (call.method == 'updateVoipToken') {
          final String voipToken = call.arguments;
          print(
              'Flutter CALL KIT VOIP Token From Dart FIle: ${FlutterCallkitIncoming.getDevicePushTokenVoIP}');
          print('VOIP VOIP Token From Dart FIle: $voipToken');
          voipTokenIOS = voipToken;
          sharedPreferences.setString(
              SharePreferenceConst.voip_device_token, voipToken);
        }
      });
    }
    callUpdateDeviceDataService();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null) {
        changePage(1);
      }
    });
  }

  Map<String, dynamic> convertPayloadNew(String payload) {
    try {
      // Remove curly braces if present
      payload = payload.replaceAll("{", "").replaceAll("}", "");

      // Split the payload into key-value pairs using ","
      List<String> keyValuePairs = payload.split(",");

      Map<String, dynamic> mapped = {};

      // Use a regular expression to match key-value pairs correctly
      for (String keyValuePair in keyValuePairs) {
        // Split using the first ":" only to handle values containing colons
        int index = keyValuePair.indexOf(':');
        if (index != -1) {
          String key = keyValuePair.substring(0, index).trim();
          String value = keyValuePair.substring(index + 1).trim();

          // Decode if the value was encoded (e.g., if it contains special characters)
          if (value.startsWith('"') && value.endsWith('"')) {
            value = value.substring(1, value.length - 1);
          }

          mapped[key] = value;
        }
      }

      return mapped;
    } catch (e) {
      print("Error converting payload to map: $e");
      return {};
    }
  }

  void callUpdateDeviceDataService() {
    Future<List<String>> data = CommonUtils.getIntance().getDeviceData();
    data.then((value) {
      Future<String?> token = FirebaseMessaging.instance.getToken();
      token.then((values) {
        String deviceToken = values.toString();
        String deviceId = value[0];
        String deviceName = value[1];
        String deviceType = Platform.isAndroid ? "android" : "ios";
        String osVersion = value[2];
        String appVersion = value[3];

        Map<String, dynamic> toJson() {
          final Map<String, dynamic> data = <String, dynamic>{};
          if (Platform.isAndroid) {
            data['device_token'] = deviceToken;
          } else if (Platform.isIOS) {
            if (deviceTokenIOS != "") {
              data['device_token'] = deviceTokenIOS;
            } else {
              data['device_token'] = sharedPreferences
                  .getString(SharePreferenceConst.apns_device_token);
            }

            if (deviceTokenIOS != "") {
              data['voip_token'] = voipTokenIOS;
            } else {
              data['voip_token'] = sharedPreferences
                  .getString(SharePreferenceConst.voip_device_token);
            }
          }
          data['device_id'] = deviceId;
          data['device_type'] = deviceType;
          data['device_name'] = deviceName;
          data['os_version'] = osVersion;
          data['app_version'] = appVersion;
          return data;
        }

        var service =
            _repository.sendPostApiRequest(toJson, update_device_token, true);
        callDataService(service,
            onSuccess: successResponseUpdateDeviceData,
            onError: handleOnError,
            isShowLoading: false);
      });
    });
  }

  Future<void> successResponseUpdateDeviceData(dynamic response) async {}

  void handleOnError(dynamic e) {
    if (e is ApiException) {}
  }

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      // Notification permissions granted
    } else if (status.isDenied) {
      // Notification permissions denied
    } else if (status.isPermanentlyDenied) {
      // Notification permissions permanently denied, open app settings
      await openAppSettings();
    }
  }

  Future<void> requestPermissions() async {
    // Request camera and microphone permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    // Check the statuses
    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted) {
      print("Permissions granted");
    } else {
      print("Permissions not granted");
    }
  }

  // added new code
  Future<void> callActionVCallService(
      String status, String callDuration) async {
    isCallEndFromScreen.value = false;

    print("notificationModel!.booking_id.toString()" +
        notificationModel!.booking_id.toString());
    print("notificationModel!.booking_slot_id.toString()" +
        notificationModel!.booking_slot_id.toString());
    print("notificationModel!.channel_id.toString()" +
        notificationModel!.channel_id.toString());
    print("notificationModel!.app_unique_call_id.toString()" +
        notificationModel!.app_unique_call_id.toString());

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['action_status'] = status;
      data['booking_id'] = notificationModel!.booking_id.toString();
      data['booking_slot_id'] = notificationModel!.booking_slot_id.toString();
      data['channel_id'] = notificationModel!.channel_id.toString();
      data['app_unique_call_id'] =
          notificationModel!.app_unique_call_id.toString();
      if (status == "call_end") {
        data['call_duration'] = callDuration;
      }
      return data;
    }

    var apiService = _repository.sendPostApiRequest(
        toJson, action_vcall_notification, false);

    callDataService(
      apiService,
      onSuccess: successResponse,
      onError: handleOnError,
      isShowLoading: true,
    );
  }

  Future<void> successResponse(dynamic baseResponse) async {
    BaseModel response = BaseModel.fromJson(baseResponse.data);
    if (response.success == true) {
      //notificationModel = null;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  // new Code added
  void notificationData(NotificationPayloadModel model) {
    notificationModel = model;
  }

  Future<void> openCallScreen(String notificationType) async {
    if (notificationType == "vcall_by_student") {
      Get.toNamed(Routes.CALL);
    }
  }

  Future<void> openCallHistoryScreen(
      String notificationType, String bookingId, String bookingSlotId) async {
    if (notificationType == "vcall_misscall_by_student" ||
        notificationType == "vcall_timeout") {
      //Get.toNamed(Routes.CALL_DETAIL,arguments: bookingSlotId);
      Get.toNamed(Routes.APPOINTMENT_DETAIL, parameters: {
        'type': '1',
        'bookingId': bookingId,
        'bookingSlotId': bookingSlotId,
        'open_call_history': "1",
      });
    }
  }

  void showAlertDialog(
      String booking_id, String booking_slot_id, String isFromList) {
    showDialog<String>(
        context: Get.context!,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                "Call Disconnected",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: Fonts.PoppinsMedium,
                    color: Clr.black),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      "Appointment time is completed, Hence call is disconnected",
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: Fonts.PoppinsMedium,
                          color: Clr.greyColor),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(AppText.okay),
                  onPressed: () async {
                    Get.back();

                    if (isFromList == "1") {
                      AppoinmentController appoinmentController =
                          Get.put(AppoinmentController(), permanent: false);
                      appoinmentController.hasMoreData = true.obs;
                      appoinmentController.currentPage = 1;
                      appoinmentController.isLoading.value = false;
                      appoinmentController.callGetBookingService("upcoming");
                      Future.delayed(
                        Duration(seconds: 1),
                        () {
                          Get.toNamed(Routes.APPOINTMENT_DETAIL, parameters: {
                            'type': '1',
                            'bookingId': booking_id,
                            'bookingSlotId': booking_slot_id,
                            'open_call_history': "0",
                          });
                        },
                      );
                    } else {
                      bookingId = booking_id;
                      bookingSlotId = booking_slot_id;
                      Get.back(result: true);
                    }
                  },
                ),
              ],
            ));
  }

  void showAlertDialogNew(String booking_id, String booking_slot_id) {
    showDialog<String>(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                "Call Disconnected",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: Fonts.PoppinsMedium,
                    color: Clr.black),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      "Appointment time is completed, Hence call is disconnected",
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: Fonts.PoppinsMedium,
                          color: Clr.greyColor),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(AppText.okay),
                  onPressed: () async {
                    Get.back();
                    if (Get.isRegistered<AppointmentDetailController>()) {
                      bookingId = booking_id;
                      bookingSlotId = booking_slot_id;
                      Get.back(result: true);
                    } else {
                      Get.toNamed(Routes.APPOINTMENT_DETAIL, parameters: {
                        'type': '1',
                        'bookingId': booking_id,
                        'bookingSlotId': booking_slot_id,
                        'open_call_history': "0",
                      });
                    }
                  },
                ),
              ],
            ));
  }
}
