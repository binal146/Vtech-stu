import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vteach_teacher/app/core/utils/api_services.dart';
import 'package:vteach_teacher/app/modules/agora_demo/agora_demo_controller.dart';
import 'package:vteach_teacher/app/modules/appointment_detail/appointment_detail_controller.dart';
import 'package:vteach_teacher/app/modules/chat/chat_controller.dart';
import 'package:vteach_teacher/app/modules/chat/model/ChatModelData.dart';
import 'package:vteach_teacher/app/modules/home/home_controller.dart';
import 'app/core/utils/common_widgets.dart';
import 'app/core/values/sharePrefrenceConst.dart';
import 'app/data/repository/project_repository.dart';
import 'app/modules/NotificationPayloadModel.dart';
import 'app/modules/agora_new/agora_demo_new_controller.dart';
import 'app/modules/appointment/appointment_controller.dart';
import 'app/modules/bottom__navigation_bar/BottomNavController.dart';
import 'app/modules/call_screen/call_controller.dart';
import 'app/my_app.dart';
import 'app/routes/app_pages.dart';
import 'flavors/build_config.dart';
import 'flavors/env_config.dart';
import 'flavors/environment.dart';

String channelId = "";

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final ProjectRepository _repository =
    Get.find(tag: (ProjectRepository).toString());

//FOR IOS CHANGES BY GAURAV
const MethodChannel platform = MethodChannel(
    "com.vTeachTeacher.vTeachTeacher_default_notifications_Comes");

Future<void> main() async {
  const Color appColor = Color(0xffF26222);

  //FOR IOS CHANGES BY GAURAV
  if (Platform.isIOS) {
    WidgetsFlutterBinding.ensureInitialized();
    handleNotificationComes();
    initializeCallkitEvents();
  }

  EnvConfig devConfig = EnvConfig(
      appName: "Vteach Teacher",
      shouldCollectCrashLog: true,
      isProduction: false,
      clientId:
          "99081688167-4nd1k7205f63o09kvelafdpvjf9a31ae.apps.googleusercontent.com");

  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: devConfig,
  );

  FirebaseMessaging.onMessageOpenedApp.listen((event) async {
    print("##Clickkkkkk");
    print("##data${event.data}");
    var dataMap = event.data;

    // new code added
    if (dataMap.toString().isNotEmpty) {
      //  await handleNotificationClick(dataMap);
      var valueMap = convertPayloadNew(event.data.toString());
      NotificationPayloadModel notificationModel1 =
          NotificationPayloadModel.fromJson(valueMap);
      if (notificationModel1.notification_type == "vcall_by_student" ||
          notificationModel1.notification_type == "vcall_call_end_by_student" ||
          notificationModel1.notification_type == "vcall_misscall_by_student" ||
          notificationModel1.notification_type == "vcall_timeout" ||
          notificationModel1.notification_type == "booking_by_student" ||
          notificationModel1.notification_type == "booking_auto_cancel" ||
          notificationModel1.notification_type == "booking_cancel_by_student" ||
          notificationModel1.notification_type == "booking_completed" ||
          notificationModel1.notification_type == "booking_auto_rejected" ||
          notificationModel1.notification_type == "save_rating") {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setBool(SharePreferenceConst.fromNotification, true);
        sharedPreferences.setString(
            SharePreferenceConst.notification_payload, event.data.toString());
      }
    }
  });

  WidgetsFlutterBinding.ensureInitialized();
  // initializeService();
  if (Platform.isIOS) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(options: currentPlatform);
  }

  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // Handle navigation based on the initial message payload
    var dataMap = initialMessage.data;
    if (dataMap.isNotEmpty) {
      // Use the declared function
      // await handleNotificationClick(dataMap);
    }
  }

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  runApp(MyApp());

  FirebaseMessaging.instance.getToken().then((value) {
    //print(value);
    print('APNs Token: $value');
  });
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {}
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(SharePreferenceConst.isLogin, true);
    sharedPreferences.setString(
        SharePreferenceConst.notification_payload, message.data.toString());
    var valueMap = convertPayloadNew(message.data.toString());
    print("EEEEEEEEEEEE" + message.data.toString());
    print("EEEEEEEEEEEE" + valueMap.toString());

    String notificationType = valueMap['notification_type'];
// added by rajnikant
    if (Get.isRegistered<HomeController>()) {
      final HomeController homeController =
          Get.put(HomeController(), permanent: false);
      homeController.callExtraDetailsService();
    }

    if (notificationType == "chat_from_student") {
      ChatModelData chatModelData = ChatModelData();
      chatModelData.id = int.parse(valueMap['id']);
      chatModelData.toUserId = int.parse(valueMap['to_user_id']);
      chatModelData.fromUserId = int.parse(valueMap['from_user_id']);
      chatModelData.bookingId = int.parse(valueMap['booking_id']);
      chatModelData.bookingSlotId = int.parse(valueMap['booking_slot_id']);
      chatModelData.messageType = valueMap['messagetype'] ?? "";
      chatModelData.message = valueMap['message'] ?? "";
      chatModelData.fileName = valueMap['file_name'] ?? "";
      chatModelData.fileUrl = valueMap['fileUrl'] ?? "";
      chatModelData.createdAt = valueMap['created_at'];
      chatModelData.fileImagePath = valueMap['file_image_path'] ?? "";

      if (Get.isRegistered<ChatController>()) {
        final ChatController chatController =
            Get.put(ChatController(), permanent: false);
        chatController.receivedNewMessage(chatModelData);
      } else {
        String title = valueMap['title'];
        String msg = "";
        if (valueMap['messagetype'] == "text") {
          msg = valueMap['message'];
        } else if (valueMap['messagetype'] == "image") {
          msg = "Received image";
        } else {
          msg = "Received file";
        }
        showChatNotification(message, title, msg);
      }
    } else {
      NotificationPayloadModel notificationModel =
          NotificationPayloadModel.fromJson(valueMap);

      if (notificationModel.notification_type == "vcall_by_student") {
        //showCallkitIncoming('111',notificationModel);
        showIncomingCallNotification(
            message,
            notificationModel.title.toString(),
            notificationModel.body.toString(),
            notificationModel);
        // open below comment
        /*payloadNotification = message.data.toString();
      _configureSelectNotificationSubject();
      showNotificationFullScreen();
      selectNotificationStream.add(message.data.toString());*/
        if (Get.isRegistered<BottomNavController>()) {
          final BottomNavController bottomNavController =
              Get.put(BottomNavController(), permanent: false);
          bottomNavController.notificationData(notificationModel);
        }
      }
      // new code added
      else if ((notificationModel.notification_type != null) &&
          (notificationModel.notification_type == "vcall_decline_by_student" ||
              notificationModel.notification_type == "vcall_timeout" ||
              notificationModel.notification_type ==
                  "vcall_misscall_by_student")) {
        final BottomNavController bottomNavController =
            Get.put(BottomNavController(), permanent: false);
        if (Get.isRegistered<CallController>()) {
          final CallController callController =
              Get.put(CallController(), permanent: false);
          callController.closeScreen();
        }
        if (Get.isRegistered<AgoraDemoNewController>()) {
          final AgoraDemoNewController agoraDemoController =
              Get.put(AgoraDemoNewController(), permanent: false);
          bottomNavController.notificationData(notificationModel);
          agoraDemoController.closeScreen();
        } else {
          if (Get.isRegistered<AgoraDemoController>()) {
            final AgoraDemoController agoraDemoController =
                Get.put(AgoraDemoController(), permanent: false);
            agoraDemoController.cancelCallTimeout();
            agoraDemoController.closeCurrentScreen();
          } else {
            bottomNavController.notificationData(notificationModel);
            dismissCallNotification(
                notificationModel.app_unique_call_id.toString());
            //showMissedCalledNotification(notificationModel);
            showMissedCallNotification(
                message,
                notificationModel.title.toString(),
                notificationModel.body.toString(),
                notificationModel);
          }
        }
      } else if (notificationModel.notification_type ==
              "vcall_reject_by_student" ||
          notificationModel.notification_type == "vcall_decline_by_student" ||
          notificationModel.notification_type == "vcall_misscall_by_student" ||
          notificationModel.notification_type == "vcall_call_end_by_student") {
        if (Get.isRegistered<AgoraDemoController>()) {
          if (Get.isRegistered<ChatController>()) {
            Get.close(2);
          } else {
            final AgoraDemoController agoraDemoController =
                Get.put(AgoraDemoController(), permanent: false);
            agoraDemoController.cancelCallTimeout();
            agoraDemoController.closeCurrentScreen();
          }
        } else if (Get.isRegistered<AgoraDemoNewController>()) {
          if (Get.isRegistered<ChatController>()) {
            Get.close(2);
          } else {
            final AgoraDemoNewController agoraDemoController =
                Get.put(AgoraDemoNewController(), permanent: false);
            agoraDemoController.cancelCallTimeout();
            agoraDemoController.callEndStatus = "vcall_call_end_by_student";
            agoraDemoController.closeScreen();
          }
        }
        /*     if(Get.isRegistered<ScreenShareController>()){
        final ScreenShareController agoraDemoController = Get.put(ScreenShareController(), permanent: false);
        // agoraDemoController.notificationData(notificationModel);
        agoraDemoController.cancelCallTimeout();
        agoraDemoController.closeCurrentScreen();
      }*/
      } else if (notificationModel.notification_type ==
          "vcall_accept_by_student") {
        if (Get.isRegistered<AgoraDemoController>()) {
          final AgoraDemoController agoraDemoController =
              Get.put(AgoraDemoController(), permanent: false);
          agoraDemoController.notificationData(notificationModel);
          agoraDemoController.cancelCallTimeout();
        }
      } else if (notificationModel.notification_type == "session_ending_soon") {
        if (Get.isRegistered<AgoraDemoController>()) {
          final AgoraDemoController agoraDemoController =
              Get.put(AgoraDemoController(), permanent: false);
          agoraDemoController
              .showAlertDialog(notificationModel.body.toString());
        }
        if (Get.isRegistered<AgoraDemoNewController>()) {
          final AgoraDemoNewController agoraDemoController =
              Get.put(AgoraDemoNewController(), permanent: false);
          agoraDemoController
              .showAlertDialog(notificationModel.body.toString());
        }
      } else if (notificationModel.notification_type ==
          "booking_session_time_completed") {
        if (Get.isRegistered<AgoraDemoController>()) {
          final AgoraDemoController agoraDemoController =
              Get.put(AgoraDemoController(), permanent: false);
          agoraDemoController.callActionVCallServiceTeacher("time_completed");
          agoraDemoController.onCompleteCall(agoraDemoController.isFromList);
        }

        if (Get.isRegistered<AgoraDemoNewController>()) {
          final AgoraDemoNewController agoraDemoController =
              Get.put(AgoraDemoNewController(), permanent: false);
          agoraDemoController.callActionVCallService(
              "time_completed",
              agoraDemoController.start.value.toString(),
              notificationModel.booking_id.toString(),
              notificationModel.booking_slot_id.toString());
          agoraDemoController.onCompleteCallNew(
              notificationModel.booking_id.toString(),
              notificationModel.booking_slot_id.toString());
        }

        if (Get.isRegistered<AppoinmentController>()) {
          final AppoinmentController appoinmentController =
              Get.put(AppoinmentController(), permanent: false);
          if (appoinmentController.isUpcoming.value) {
            appoinmentController.hasMoreData = true.obs;
            appoinmentController.currentPage = 1;
            appoinmentController.isLoading.value = false;
            appoinmentController.callGetBookingService('upcoming');
          } else {
            appoinmentController.hasMoreData = true.obs;
            appoinmentController.currentPage = 1;
            appoinmentController.isLoading.value = false;
            appoinmentController.callGetBookingService('past');
          }
        }

        if (Get.isRegistered<AppointmentDetailController>()) {
          final AppointmentDetailController appointmentDetailController =
              Get.put(AppointmentDetailController(), permanent: false);

          if (appointmentDetailController.bookingSlotId.toString() ==
              notificationModel.booking_slot_id.toString()) {
            appointmentDetailController.appointmentType.value = "1";
            appointmentDetailController.callGetBookingDetailService();
          }
        }
      } else {
        if (notificationModel.notification_type == "booking_by_student") {
          showNotificationNewBooking(
              message,
              notificationModel.title.toString(),
              notificationModel.body.toString(),
              notificationModel);
        } else {
          showNotification(message, notificationModel.title.toString(),
              notificationModel.body.toString(), notificationModel);
        }
        if (notificationModel.notification_type == "booking_by_student" ||
            notificationModel.notification_type == "booking_auto_rejected") {
          if (Get.isRegistered<HomeController>()) {
            final HomeController homeController =
                Get.put(HomeController(), permanent: false);
            homeController.hasMoreData = true.obs;
            homeController.currentPage = 1;
            homeController.isLoading.value = false;
            homeController.callGetPendingBooking();
          }
        } else if (notificationModel.notification_type == "profile_approve") {
          if (Get.isRegistered<HomeController>()) {
            final HomeController homeController =
                Get.put(HomeController(), permanent: false);
            homeController.callGetCheckAvailabilityService();
          }
        } else if (notificationModel.notification_type ==
                "booking_auto_cancel" ||
            notificationModel.notification_type ==
                "booking_cancel_by_student" ||
            notificationModel.notification_type == "booking_completed" ||
            notificationModel.notification_type == "booking_auto_rejected" ||
            notificationModel.notification_type == "save_rating") {
          if (Get.isRegistered<AppoinmentController>()) {
            final AppoinmentController appoinmentController =
                Get.put(AppoinmentController(), permanent: false);
            if (appoinmentController.isUpcoming.value) {
              appoinmentController.hasMoreData = true.obs;
              appoinmentController.currentPage = 1;
              appoinmentController.isLoading.value = false;
              appoinmentController.callGetBookingService('upcoming');
            } else {
              appoinmentController.hasMoreData = true.obs;
              appoinmentController.currentPage = 1;
              appoinmentController.isLoading.value = false;
              appoinmentController.callGetBookingService('past');
            }
          }

          if (Get.isRegistered<AppointmentDetailController>()) {
            final AppointmentDetailController appointmentDetailController =
                Get.put(AppointmentDetailController(), permanent: false);

            if (appointmentDetailController.bookingSlotId.toString() ==
                notificationModel.booking_slot_id.toString()) {
              appointmentDetailController.appointmentType.value = "1";
              appointmentDetailController.callGetBookingDetailService();
            }
          }
        }
      }
    }
  });

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  // Define iOS settings here
  var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  final didNotificationLaunchApp =
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
  if (didNotificationLaunchApp) {
    // var payload = notificationAppLaunchDetails!.notificationResponse;
    if (notificationAppLaunchDetails!.notificationResponse != null &&
        notificationAppLaunchDetails
            .notificationResponse!.payload!.isNotEmpty) {
      var valueMap = convertPayloadNew(notificationAppLaunchDetails
          .notificationResponse!.payload
          .toString());
      /*NotificationPayloadModel notificationModel =
      NotificationPayloadModel.fromJson(valueMap);

      if (notificationModel.notification_type!.trim().toString().compareTo("customs") == 1) {
        var result = await Get.toNamed(Routes.ORDER_DETAIL, parameters: {
          'id': notificationModel.order_id.toString(),
          "result": "true"
        });
        if (result == true) {
          await Get.offAllNamed(Routes.BOTTOM_NAVIGATION_NEW);
        }
      }*/
    }
  }
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponse);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  print("onDidReceiveNotificationResponse:::" +
      notificationResponse.payload.toString());
  if (notificationResponse.payload != null &&
      notificationResponse.payload!.isNotEmpty) {
    var valueMap = convertPayloadNew(notificationResponse.payload.toString());

    String notificationType = valueMap['notification_type'];

    if (notificationType == "chat_from_student") {
      String studentId = valueMap['from_user_id'];
      String bookingId = valueMap['booking_id'];
      String bookingSlotId = valueMap['booking_slot_id'];
      String studentName = valueMap['title'];
      Get.toNamed(Routes.CHAT, parameters: {
        'student_id': studentId,
        'booking_id': bookingId,
        'booking_slot_id': bookingSlotId,
        'student_name': studentName,
      });
    } else {
      NotificationPayloadModel notificationModel =
          NotificationPayloadModel.fromJson(valueMap);

      if (notificationModel.notification_type.toString() ==
          "booking_by_student") {
        var result = await Get.toNamed(Routes.REQUEST_APPOINTMENT_DETAIL,
            arguments: notificationModel.booking_id.toString(),
            parameters: {'fromNotification': "0"});
        if (result == true) {
          if (Get.isRegistered<HomeController>()) {
            final HomeController homeController =
                Get.put(HomeController(), permanent: false);
            homeController.hasMoreData = true.obs;
            homeController.currentPage = 1;
            homeController.isLoading.value = false;
            homeController.callGetPendingBooking();
          }
        }
      }

      if (notificationModel.notification_type == "booking_auto_cancel" ||
          notificationModel.notification_type == "booking_cancel_by_student" ||
          notificationModel.notification_type == "booking_completed" ||
          notificationModel.notification_type == "booking_auto_rejected" ||
          notificationModel.notification_type == "save_rating") {
        Get.toNamed(Routes.APPOINTMENT_DETAIL, parameters: {
          'type': '1',
          'bookingId': notificationModel.booking_id.toString(),
          'bookingSlotId': notificationModel.booking_slot_id.toString(),
          'open_call_history': "0",
        });
      }

      if (notificationModel.notification_type == "vcall_by_student") {
        final BottomNavController bottomNavController =
            Get.put(BottomNavController(), permanent: false);
        if (Get.isRegistered<BottomNavController>()) {
          print('Message data:AAAAAAAAAAA ');
          final BottomNavController agoraDemoController =
              Get.put(BottomNavController(), permanent: false);
          bottomNavController.notificationData(notificationModel);
          agoraDemoController
              .openCallScreen(notificationModel.notification_type.toString());
        }
      }

      if (notificationModel.notification_type == "vcall_misscall_by_student" ||
          notificationModel.notification_type == "vcall_timeout") {
        if (Get.isRegistered<BottomNavController>()) {
          print('Message data:AAAAAAAAAAA ');
          final BottomNavController bottomNavController =
              Get.put(BottomNavController(), permanent: false);
          bottomNavController.notificationData(notificationModel);
          bottomNavController.openCallHistoryScreen(
              notificationModel.notification_type.toString(),
              notificationModel.booking_id.toString(),
              notificationModel.booking_slot_id.toString());
        }
      }
    }
  }
}

@pragma('vm:entry-point')
Future<void> _messageHandler(RemoteMessage message) async {
  print('Got a message whilst in the background!');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.body.toString()}');
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await setupFlutterNotifications();
  //showNotification(message);

  // new code added
  var valueMap = convertPayloadNew(message.data.toString());

  String notificationType = valueMap['notification_type'];

  if (notificationType == "chat_from_student") {
    ChatModelData chatModelData = ChatModelData();
    chatModelData.id = int.parse(valueMap['id']);
    chatModelData.toUserId = int.parse(valueMap['to_user_id']);
    chatModelData.fromUserId = int.parse(valueMap['from_user_id']);
    chatModelData.bookingId = int.parse(valueMap['booking_id']);
    chatModelData.bookingSlotId = int.parse(valueMap['booking_slot_id']);
    chatModelData.messageType = valueMap['messagetype'] ?? "";
    chatModelData.message = valueMap['message'] ?? "";
    chatModelData.fileName = valueMap['file_name'] ?? "";
    chatModelData.fileUrl = valueMap['fileUrl'] ?? "";
    chatModelData.createdAt = valueMap['created_at'];
    chatModelData.fileImagePath = valueMap['file_image_path'] ?? "";

    if (Get.isRegistered<ChatController>()) {
      final ChatController chatController =
          Get.put(ChatController(), permanent: false);
      chatController.receivedNewMessage(chatModelData);
    } else {
      String title = valueMap['title'];
      String msg = "";
      if (valueMap['messagetype'] == "text") {
        msg = valueMap['message'];
      } else if (valueMap['messagetype'] == "image") {
        msg = "Received image";
      } else {
        msg = "Received file";
      }
      showChatNotification(message, title, msg);
    }
  } else {
    NotificationPayloadModel notificationModel =
        NotificationPayloadModel.fromJson(valueMap);
    print("RAJNIKANT --->" + notificationModel.notification_type.toString());

    if (notificationModel.notification_type == "vcall_by_student" ||
        notificationModel.notification_type == "vcall_call_end_by_student" ||
        notificationModel.notification_type == "vcall_misscall_by_student" ||
        notificationModel.notification_type == "vcall_timeout" ||
        notificationModel.notification_type == "booking_by_student" ||
        notificationModel.notification_type == "booking_auto_cancel" ||
        notificationModel.notification_type == "booking_cancel_by_student" ||
        notificationModel.notification_type == "booking_completed" ||
        notificationModel.notification_type == "booking_auto_rejected") {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool(SharePreferenceConst.fromNotification, true);
      sharedPreferences.setString(
          SharePreferenceConst.notification_payload, message.data.toString());
    }

    if (notificationModel.notification_type != null &&
        notificationModel.notification_type == "vcall_by_student") {
      //showCallkitIncoming('111',notificationModel);
      showIncomingCallNotification(message, notificationModel.title.toString(),
          notificationModel.body.toString(), notificationModel);

      if (Get.isRegistered<BottomNavController>()) {
        final BottomNavController bottomNavController =
            Get.put(BottomNavController(), permanent: false);
        bottomNavController.notificationData(notificationModel);
      }
    } else if ((notificationModel.notification_type != null) &&
        (notificationModel.notification_type == "vcall_timeout" ||
            notificationModel.notification_type ==
                "vcall_misscall_by_student")) {
      if (Get.isRegistered<CallController>()) {
        final CallController callController =
            Get.put(CallController(), permanent: false);
        callController.closeScreen();
      }
      if (Get.isRegistered<AgoraDemoNewController>()) {
        final BottomNavController bottomNavController =
            Get.put(BottomNavController(), permanent: false);
        final AgoraDemoNewController agoraDemoController =
            Get.put(AgoraDemoNewController(), permanent: false);
        bottomNavController.notificationData(notificationModel);
        agoraDemoController.closeScreen();
      } else {
        dismissCallNotification(
            notificationModel.app_unique_call_id.toString());
        // showMissedCalledNotification(notificationModel);
        showMissedCallNotification(message, notificationModel.title.toString(),
            notificationModel.body.toString(), notificationModel);
      }
    } else if (notificationModel.notification_type != null &&
            notificationModel.notification_type ==
                "vcall_call_end_by_student" ||
        notificationModel.notification_type == "vcall_decline_by_student") {
      final BottomNavController bottomNavController =
          Get.put(BottomNavController(), permanent: false);
      if (Get.isRegistered<AgoraDemoNewController>()) {
        final AgoraDemoNewController agoraDemoController =
            Get.put(AgoraDemoNewController(), permanent: false);
        bottomNavController.notificationData(notificationModel);
        agoraDemoController.callEndStatus = "vcall_call_end_by_student";
        agoraDemoController.closeScreen();
      } else {
        // dismissCallNotification();
      }
    } else {
      if (notificationModel.notification_type == "booking_by_student") {
        showNotificationNewBooking(message, notificationModel.title.toString(),
            notificationModel.body.toString(), notificationModel);
      } else {
        showNotification(message, notificationModel.title.toString(),
            notificationModel.body.toString(), notificationModel);
      }
    }
  }
}

bool isFlutterLocalNotificationsInitialized = false;

AndroidNotificationChannel? channel;

Future<void> setupFlutterNotifications() async {
  channelId = "vteach_teacher";
  channel = AndroidNotificationChannel(
    channelId, // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true,
    enableLights: true,
    //sound: RawResourceAndroidNotificationSound(Constants.notification_sound), // Replace 'custom_sound' with the name of your sound file
  );

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  //{notification_type: program_assign, notification_type_id: 5, notification_id: 176446, body: Post Surgery for Finger  program assign by Zydius clinic, title: Assign Program}

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showNotificationOld(RemoteMessage message, String title, String body) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.body.toString()}');

  RemoteNotification? notification = message.notification;
  var data = message.data;
  /* if (Get.isRegistered<BottomController>()) {
    final BottomController bottomControllerNew =
    Get.put(BottomController(), permanent: false);
    if (data['unread_counts'] != null) {
      bottomControllerNew.notificationCount.value =
          int.parse(data['unread_counts'].toString());
    }
  }*/

  if (notification != null) {
    print("############# channel id -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id.toString(),
            channel!.name.toString(),
            channelDescription: channel?.description,
            enableLights: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: message.data.toString());
  } else {
    print("############# channel id 111 -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id.toString(),
            channel!.name.toString(),
            channelDescription: channel?.description,
            enableLights: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: message.data.toString());
  }
}

Map<String, dynamic> convertPayload(String payload) {
  final String payload0 = payload.substring(1, payload.length - 1);
  List<String> split = [];
  payload0.split(",").forEach((String s) => split.addAll(s.split(":")));
  Map<String, dynamic> mapped = {};
  for (int i = 0; i < split.length + 1; i++) {
    if (i % 2 == 1)
      mapped.addAll({split[i - 1].trim().toString(): split[i].trim()});
  }
  return mapped;
}

Map<String, dynamic> convertPayloadNewOld(String payload) {
  try {
    // Remove curly braces if present
    payload = payload.replaceAll("{", "").replaceAll("}", "");

    // Split the payload into key-value pairs using ","
    List<String> keyValuePairs = payload.split(",");

    Map<String, dynamic> mapped = {};

    // Split each key-value pair using ":"
    for (String keyValuePair in keyValuePairs) {
      List<String> keyValue = keyValuePair.split(":");

      if (keyValue.length == 2) {
        // Trim whitespace from the key and value and add to the map
        String key = keyValue[0].trim();
        String value = keyValue[1].trim();
        mapped[key] = value;
      }
    }

    return mapped;
  } catch (e) {
    print("Error converting payload to map: $e");
    return {};
  }
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

FirebaseOptions get currentPlatform {
  // ignore: missing_enum_constant_in_switch
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return android;
    case TargetPlatform.iOS:
      return ios;
    case TargetPlatform.fuchsia:
      // If you have specific options for fuchsia, return them here
      // return fuchsiaOptions;
      break;
    default:
      throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for this platform.',
      );
  }
  throw UnsupportedError(
    'DefaultFirebaseOptions are not supported for this platform.',
  );
}

const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyCloMvvGo6Qs4hX2cefaT8RAkPQ9zLoJeo',
  appId: '1:255644132869:android:d6fb7f68dba7cfc995de6c',
  messagingSenderId: '255644132869',
  projectId: 'demoprojects-4cbb9',
);

const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'AIzaSyCevO1XbAVJVAIjp_4RVQ9Bj1MqYC4NBV8',
  appId: '1:255644132869:ios:1b712159d546999495de6c',
  messagingSenderId: '255644132869',
  projectId: 'demoprojects-4cbb9',
  iosBundleId: 'com.vteach.teacher',
);

void showNotification(RemoteMessage message, String title, String body,
    NotificationPayloadModel notificationModel) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.body.toString()}');

  if (channel == null) {
    print('Channel is null');
    channel = AndroidNotificationChannel(
      "vteach_teacher", // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true,
      enableLights: true,
      enableVibration: false,
      sound: RawResourceAndroidNotificationSound(notificationModel.sound),
      //sound: RawResourceAndroidNotificationSound(Constants.notification_sound), // Replace 'custom_sound' with the name of your sound file
    );
  }

  RemoteNotification? notification = message.notification;
  if (notification != null) {
    print("############# channel id -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        // int.parse(notificationModel.app_unique_call_id!),
        notification.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              channel!.id.toString(), channel!.name.toString(),
              channelDescription: channel?.description,
              enableLights: true,
              playSound: true,
              icon: '@mipmap/ic_launcher',
              importance: Importance.high,
              priority: Priority.high,
              fullScreenIntent: true),
        ),
        payload: message.data.toString());
  } else {
    print("############# channel id 111 -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        //int.parse(notificationModel.app_unique_call_id!),
        notification.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id.toString(),
            channel!.name.toString(),
            channelDescription: channel?.description,
            enableLights: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: message.data.toString());
  }
}

void showNotificationNewBooking(RemoteMessage message, String title,
    String body, NotificationPayloadModel notificationModel) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.body.toString()}');

  if (channel == null) {
    print('Channel is null');
    channel = AndroidNotificationChannel(
      "vteach_teacher", // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true,
      enableLights: true,
      enableVibration: false,
      sound: RawResourceAndroidNotificationSound(notificationModel.sound),
      //sound: RawResourceAndroidNotificationSound(Constants.notification_sound), // Replace 'custom_sound' with the name of your sound file
    );
  }

  RemoteNotification? notification = message.notification;
  if (notification != null) {
    print("############# channel id -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        // int.parse(notificationModel.app_unique_call_id!),
        int.parse(notificationModel.booking_id!),
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              channel!.id.toString(), channel!.name.toString(),
              channelDescription: channel?.description,
              enableLights: true,
              playSound: true,
              icon: '@mipmap/ic_launcher',
              importance: Importance.high,
              priority: Priority.high,
              fullScreenIntent: true),
        ),
        payload: message.data.toString());
  } else {
    print("############# channel id 111 -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        //int.parse(notificationModel.app_unique_call_id!),
        int.parse(notificationModel.booking_id!),
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id.toString(),
            channel!.name.toString(),
            channelDescription: channel?.description,
            enableLights: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: message.data.toString());
  }
}

void showChatNotification(RemoteMessage message, String title, String body) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.body.toString()}');

  if (channel == null) {
    print('Channel is null');
    channel = AndroidNotificationChannel(
      "vteach_teacher", // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true,
      enableLights: true,
      enableVibration: false,
    );
  }

  RemoteNotification? notification = message.notification;
  if (notification != null) {
    print("############# channel id -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        // int.parse(notificationModel.app_unique_call_id!),
        notification.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              channel!.id.toString(), channel!.name.toString(),
              channelDescription: channel?.description,
              enableLights: true,
              playSound: true,
              icon: '@mipmap/ic_launcher',
              importance: Importance.high,
              priority: Priority.high,
              fullScreenIntent: true),
        ),
        payload: message.data.toString());
  } else {
    print("############# channel id 111 -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        //int.parse(notificationModel.app_unique_call_id!),
        notification.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id.toString(),
            channel!.name.toString(),
            channelDescription: channel?.description,
            enableLights: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: message.data.toString());
  }
}

void showMissedCallNotification(RemoteMessage message, String title,
    String body, NotificationPayloadModel notificationModel) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.body.toString()}');

  if (channel == null) {
    print('Channel is null');
    channel = AndroidNotificationChannel(
      "vteach_teacher", // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true,
      enableLights: true,
      enableVibration: false,
      sound: RawResourceAndroidNotificationSound(notificationModel.sound),
      //sound: RawResourceAndroidNotificationSound(Constants.notification_sound), // Replace 'custom_sound' with the name of your sound file
    );
  }

  RemoteNotification? notification = message.notification;
  if (notification != null) {
    print("############# channel id -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        int.parse(notificationModel.app_unique_call_id!),
        "Missed Call",
        notificationModel.full_name.toString(),
        NotificationDetails(
          android: AndroidNotificationDetails(
              channel!.id.toString(), channel!.name.toString(),
              channelDescription: channel?.description,
              enableLights: true,
              playSound: true,
              icon: '@mipmap/ic_launcher',
              importance: Importance.high,
              priority: Priority.high,
              fullScreenIntent: true),
        ),
        payload: message.data.toString());
  } else {
    print("############# channel id 111 -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        int.parse(notificationModel.app_unique_call_id!),
        "Missed Call",
        notificationModel.full_name.toString(),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id.toString(),
            channel!.name.toString(),
            channelDescription: channel?.description,
            enableLights: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: message.data.toString());
  }
}

void showIncomingCallNotification(RemoteMessage message, String title,
    String body, NotificationPayloadModel notificationModel) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.body.toString()}');

  if (channel == null) {
    print('Channel is null');
    channel = AndroidNotificationChannel(
      "vteach_teacher", // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true,
      enableLights: true,
      enableVibration: false,
      sound: RawResourceAndroidNotificationSound(notificationModel
          .sound), // Replace 'custom_sound' with the name of your sound file
    );
  }

  RemoteNotification? notification = message.notification;
  if (notification != null) {
    print("############# channel id -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        int.parse(notificationModel.app_unique_call_id!),
        title,
        notificationModel.full_name.toString(),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id.toString(),
            channel!.name.toString(),
            channelDescription: channel?.description,
            enableLights: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
            fullScreenIntent: true,
            ongoing: true,
            autoCancel: true,
            enableVibration: false,
            vibrationPattern: Int64List(0), // Set an empty vibration pattern
            additionalFlags: Int32List.fromList(<int>[4]),
            sound: RawResourceAndroidNotificationSound(notificationModel.sound),
          ),
        ),
        payload: message.data.toString());
  } else {
    print("############# channel id 111 -- " + channel!.id.toString());
    flutterLocalNotificationsPlugin.show(
        int.parse(notificationModel.app_unique_call_id!),
        title,
        notificationModel.full_name.toString(),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id.toString(),
            channel!.name.toString(),
            channelDescription: channel?.description,
            enableLights: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            ongoing: true,
            autoCancel: true,
            enableVibration: false,
            vibrationPattern: Int64List(0), // Set an empty vibration pattern
            additionalFlags: Int32List.fromList(<int>[4]),
            sound: RawResourceAndroidNotificationSound(notificationModel.sound),
          ),
        ),
        payload: message.data.toString());
  }
}

void dismissCallNotification(String notificationId) async {
  await flutterLocalNotificationsPlugin.cancel(int.parse(notificationId));
}

Future<void> callActionVCallServiceStudent(Map<String, dynamic>? data,
    NotificationPayloadModel? callData, String? callStatus) async {
  print("API call data ---> $data");

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? token = sharedPreferences.getString(SharePreferenceConst.token);

  bool? isLogin = false;
  if (sharedPreferences.getBool(SharePreferenceConst.isLogin) != null) {
    isLogin = sharedPreferences.getBool(SharePreferenceConst.isLogin);
  }

  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

  dio.Dio dioInstance = dio.Dio();
  const String url = baseUrlDev + action_vcall_notification;
  print('Full URL: $url');

  try {
    dio.Response response = await dioInstance.post(
      url,
      data: data,
      options: dio.Options(
        headers: {
          'Content-Type': 'application/json',
          'timezone': currentTimeZone,
          'Authorization': "Bearer $token",
        },
      ),
    );
    print('Response: ${response.data}');
    if (response.statusCode == 200) {
      if (callStatus == "accept") {
        Get.toNamed(Routes.AGORA_DEMO_NEW, arguments: callData);
      } else {
        Get.back();
      }
      print('Request success with status: 200');
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Error response body: ${response.data}');
    }
  } catch (e) {
    print('Request error: $e');
  }
}

//FOR IOS CHANGES BY GAURAV
void handleNotificationComes() {
  platform.setMethodCallHandler((call) async {
    if (call.method == 'onNotificationCome') {
      final extra = call.arguments['extraPayLoad'];
      var data = extra.toString();
      print('extra.toString(),$data');
      print(call.arguments['notification_type'].toString());
      var callData = convertPayloadNew(data);
      var notificationModel = NotificationPayloadModel.fromJson(callData);
      if (call.arguments['notification_type'].toString() ==
          "vcall_by_student") {
        showIncomingCallNotification(
            '' as RemoteMessage,
            notificationModel.title.toString(),
            notificationModel.body.toString(),
            notificationModel);
        if (Get.isRegistered<BottomNavController>()) {
          print('BottomNavController notificationModel init');
          final BottomNavController bottomNavController =
              Get.put(BottomNavController(), permanent: false);
          bottomNavController.notificationData(notificationModel);
        }
      }
      // new code added
      else if ((call.arguments['notification_type'].toString() != null) &&
          (call.arguments['notification_type'].toString() ==
                  "vcall_decline_by_student" ||
              call.arguments['notification_type'].toString() ==
                  "vcall_timeout" ||
              call.arguments['notification_type'].toString() ==
                  "vcall_misscall_by_student")) {
        final BottomNavController bottomNavController =
            Get.put(BottomNavController(), permanent: false);
        if (Get.isRegistered<CallController>()) {
          final CallController callController =
              Get.put(CallController(), permanent: false);
          callController.closeScreen();
        }
        if (Get.isRegistered<AgoraDemoNewController>()) {
          final AgoraDemoNewController agoraDemoController =
              Get.put(AgoraDemoNewController(), permanent: false);
          bottomNavController.notificationData(notificationModel);
          agoraDemoController.closeScreen();
        } else {
          if (Get.isRegistered<AgoraDemoController>()) {
            final AgoraDemoController agoraDemoController =
                Get.put(AgoraDemoController(), permanent: false);
            agoraDemoController.cancelCallTimeout();
            agoraDemoController.closeCurrentScreen();
          } else {
            bottomNavController.notificationData(notificationModel);
            dismissCallNotification(
                notificationModel.app_unique_call_id.toString());
            //showMissedCalledNotification(notificationModel);
            showMissedCallNotification(
                '' as RemoteMessage,
                notificationModel.title.toString(),
                notificationModel.body.toString(),
                notificationModel);
          }
        }
      } else if (notificationModel.notification_type ==
              "vcall_reject_by_student" ||
          call
                  .arguments['notification_type']
                  .toString() ==
              "vcall_decline_by_student" ||
          call.arguments['notification_type'].toString() ==
              "vcall_misscall_by_student" ||
          call.arguments['notification_type'].toString() ==
              "vcall_call_end_by_student") {
        print("vcall_call_end_by_student");
        if (Platform.isIOS) {
          FlutterCallkitIncoming.endAllCalls();
        }
        if (Get.isRegistered<AgoraDemoController>()) {
          final AgoraDemoController agoraDemoController =
              Get.put(AgoraDemoController(), permanent: false);
          agoraDemoController.cancelCallTimeout();
          agoraDemoController.closeCurrentScreen();
        } else if (Get.isRegistered<AgoraDemoNewController>()) {
          final AgoraDemoNewController agoraDemoController =
              Get.put(AgoraDemoNewController(), permanent: false);
          agoraDemoController.cancelCallTimeout();
          agoraDemoController.callEndStatus = "vcall_call_end_by_student";
          agoraDemoController.closeScreen();
        }
        /*     if(Get.isRegistered<ScreenShareController>()){
        final ScreenShareController agoraDemoController = Get.put(ScreenShareController(), permanent: false);
        // agoraDemoController.notificationData(notificationModel);
        agoraDemoController.cancelCallTimeout();
        agoraDemoController.closeCurrentScreen();
      }*/
      } else if (call.arguments['notification_type'].toString() ==
          "vcall_accept_by_student") {
        if (Get.isRegistered<AgoraDemoController>()) {
          final AgoraDemoController agoraDemoController =
              Get.put(AgoraDemoController(), permanent: false);
          print(notificationModel.toJson().toString());
          agoraDemoController.notificationData(notificationModel);
          agoraDemoController.cancelCallTimeout();
        }
      } else if (call.arguments['notification_type'].toString() ==
          "session_ending_soon") {
        if (Get.isRegistered<AgoraDemoController>()) {
          final AgoraDemoController agoraDemoController =
              Get.put(AgoraDemoController(), permanent: false);
          agoraDemoController
              .showAlertDialog(notificationModel.body.toString());
        }
        if (Get.isRegistered<AgoraDemoNewController>()) {
          final AgoraDemoNewController agoraDemoController =
              Get.put(AgoraDemoNewController(), permanent: false);
          agoraDemoController
              .showAlertDialog(notificationModel.body.toString());
        }
      } else if (call.arguments['notification_type'].toString() ==
          "booking_session_time_completed") {
        if (Get.isRegistered<AgoraDemoController>()) {
          final AgoraDemoController agoraDemoController =
              Get.put(AgoraDemoController(), permanent: false);
          agoraDemoController.callActionVCallServiceTeacher("time_completed");
          agoraDemoController.onCompleteCall(agoraDemoController.isFromList);
        }
        if (Get.isRegistered<AgoraDemoNewController>()) {
          final AgoraDemoNewController agoraDemoController =
              Get.put(AgoraDemoNewController(), permanent: false);
          agoraDemoController.callActionVCallService(
              "time_completed",
              agoraDemoController.start.value.toString(),
              notificationModel.booking_id.toString(),
              notificationModel.booking_slot_id.toString());
          agoraDemoController.onCompleteCallNew(
              notificationModel.booking_id.toString(),
              notificationModel.booking_slot_id.toString());
        }
        if (Get.isRegistered<AppoinmentController>()) {
          final AppoinmentController appoinmentController =
              Get.put(AppoinmentController(), permanent: false);
          if (appoinmentController.isUpcoming.value) {
            appoinmentController.hasMoreData = true.obs;
            appoinmentController.currentPage = 1;
            appoinmentController.isLoading.value = false;
            appoinmentController.callGetBookingService('upcoming');
          } else {
            appoinmentController.hasMoreData = true.obs;
            appoinmentController.currentPage = 1;
            appoinmentController.isLoading.value = false;
            appoinmentController.callGetBookingService('past');
          }
        }
      } else {
        // if (call.arguments['notification_type'].toString() ==
        //     "booking_by_student") {
        //   showNotificationNewBooking(
        //       '' as RemoteMessage,
        //       notificationModel.title.toString(),
        //       notificationModel.body.toString(),
        //       notificationModel);
        // } else {
        //   showNotification(
        //       '' as RemoteMessage,
        //       notificationModel.title.toString(),
        //       notificationModel.body.toString(),
        //       notificationModel);
        // }
        if (call.arguments['notification_type'].toString() ==
                "booking_by_student" ||
            call.arguments['notification_type'].toString() ==
                "booking_auto_rejected") {
          print('booking_by_student function called');
          if (Get.isRegistered<HomeController>()) {
            final HomeController homeController =
                Get.put(HomeController(), permanent: false);
            homeController.hasMoreData = true.obs;
            homeController.currentPage = 1;
            homeController.isLoading.value = false;
            homeController.callGetPendingBooking();
          }
        } else if (call.arguments['notification_type'].toString() ==
            "profile_approve") {
          if (Get.isRegistered<HomeController>()) {
            final HomeController homeController =
                Get.put(HomeController(), permanent: false);
            homeController.callGetCheckAvailabilityService();
          }
        } else if (call.arguments['notification_type'].toString() ==
                "booking_auto_cancel" ||
            call.arguments['notification_type'].toString() ==
                "booking_cancel_by_student" ||
            call.arguments['notification_type'].toString() ==
                "booking_completed" ||
            call.arguments['notification_type'].toString() ==
                "booking_auto_rejected") {
          if (Get.isRegistered<AppoinmentController>()) {
            final AppoinmentController appoinmentController =
                Get.put(AppoinmentController(), permanent: false);
            if (appoinmentController.isUpcoming.value) {
              appoinmentController.hasMoreData = true.obs;
              appoinmentController.currentPage = 1;
              appoinmentController.isLoading.value = false;
              appoinmentController.callGetBookingService('upcoming');
            } else {
              appoinmentController.hasMoreData = true.obs;
              appoinmentController.currentPage = 1;
              appoinmentController.isLoading.value = false;
              appoinmentController.callGetBookingService('past');
            }
          }
        }
      }
    }
  });
}

void initializeCallkitEvents() {
  var status = "";
  NotificationPayloadModel? notificationModel;

  FlutterCallkitIncoming.onEvent.listen((event) async {
    switch (event!.event) {
      case Event.actionCallAccept:
        // Extract the extra data from the event body
        status = "accept";
        final Map<String, dynamic> data = <String, dynamic>{};
        final extra = event.body['extra'];
        var callData = convertPayloadNew(extra.toString());
        notificationModel = NotificationPayloadModel.fromJson(callData);
        data['action_status'] = status;

        data['booking_id'] = notificationModel?.booking_id.toString();
        data['booking_slot_id'] = notificationModel?.booking_slot_id.toString();
        data['channel_id'] = notificationModel?.channel_id.toString();
        data['app_unique_call_id'] =
            notificationModel?.app_unique_call_id.toString();
        callActionVCallServiceStudent(data, notificationModel, status);
        break;

      case Event.actionCallDecline:
        print("Call Declined");
        // End the Agora call or clean up resources if needed
        status = "decline";
        final Map<String, dynamic> data = <String, dynamic>{};
        final extra = event.body['extra'];
        var callData = convertPayloadNew(extra.toString());
        notificationModel = NotificationPayloadModel.fromJson(callData);
        data['action_status'] = status;

        data['booking_id'] = notificationModel?.booking_id.toString();
        data['booking_slot_id'] = notificationModel?.booking_slot_id.toString();
        data['channel_id'] = notificationModel?.channel_id.toString();
        data['app_unique_call_id'] =
            notificationModel?.app_unique_call_id.toString();
        callActionVCallServiceStudent(data, notificationModel, status);
        break;

      case Event.actionCallEnded:
        print("Call Ended");

        break;

      default:
        print("Unhandled Callkit Event: ${event.event}");
        break;
    }
  });
}
