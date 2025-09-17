import 'dart:async';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/comman_text.dart';
import '../../core/values/text_styles.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../NotificationPayloadModel.dart';
import '../bottom__navigation_bar/BottomNavController.dart';
import '/app/core/base/base_controller.dart';

class AgoraDemoNewController extends BaseController
    with WidgetsBindingObserver {
  final ProjectRepository _repository =
      Get.find(tag: (ProjectRepository).toString());

  final BottomNavController bottomNavController =
      Get.put(BottomNavController(), permanent: false);

  String token = "";
  String channelName = "";
  String uid = "";
  String appId = "";

  late final RtcEngineEx engine;

  RxBool isJoined = false.obs,
      isScreenShare = false.obs,
      isScreenShareTemp = false.obs,
      switchCamera = true.obs,
      switchRender = true.obs,
      openCamera = true.obs,
      muteCamera = false.obs,
      muteAudio = false.obs,
      speakerPhone = true.obs,
      isEngineReady = false.obs,
      muteVideo = false.obs,
      muteAllRemoteVideo = false.obs;

  Set<int> remoteUID = <int>{}.obs;
  RxBool isUseFlutterTexture = false.obs;
  bool isUseAndroidSurfaceView = true;
  ChannelProfileType channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  late final RtcEngineEventHandler rtcEngineEventHandler;

  //String channelId = "";

  Timer? timer;
  RxInt start = 0.obs;
  RxString duration = "00:00".obs;

  //late NotificationPayloadModel notificationModel;

  RxString teacherName = "".obs;
  RxString teacherProfile = "".obs;

  int screenShareTeacherUid = 11111;
  var isUpdatingScreen = false.obs;
  String callEndStatus = "";

  int callEndValue = 0;

  String bookingId = "";
  String bookingSlotId = "";
  String teacherId = "";
  String studentId = "";

  RxBool isRemoteInternetOn = true.obs;
  RxBool isLocalInternetOn = true.obs;

  Timer? remoteInternetTimer;
  Timer? localInternetTimer;

  // iOS
  late NotificationPayloadModel notificationModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    // notificationModel = Get.arguments;

    WidgetsBinding.instance.addObserver(this);
    //FOR IOS CHANGES BY GAURAV
    if (Platform.isIOS) {
      print('Get.arguments from agora new');
      print(Get.arguments);
      notificationModel = Get.arguments;
      token = notificationModel.agoratoken.toString();
      channelName = notificationModel.channel_id.toString();
      uid = notificationModel.student_uid.toString();
      appId = notificationModel.agoraAppId.toString();
      teacherName.value = notificationModel.full_name.toString();
      teacherProfile.value = notificationModel.profile_image.toString();

      // added by rajnikant
      studentId = notificationModel.student_id.toString();
      teacherId = notificationModel.teacher_id.toString();
      bookingId = notificationModel.booking_id.toString();
      bookingSlotId = notificationModel.booking_slot_id.toString();
      bottomNavController.notificationData(notificationModel);
    } else {
      token = bottomNavController.notificationModel!.agoratoken.toString();
      channelName =
          bottomNavController.notificationModel!.channel_id.toString();
      uid = bottomNavController.notificationModel!.student_uid.toString();
      appId = bottomNavController.notificationModel!.agoraAppId.toString();

      teacherName.value =
          bottomNavController.notificationModel!.full_name.toString();
      teacherProfile.value =
          bottomNavController.notificationModel!.profile_image.toString();
      studentId = bottomNavController.notificationModel!.student_id.toString();
      teacherId = bottomNavController.notificationModel!.teacher_id.toString();
      bookingId = bottomNavController.notificationModel!.booking_id.toString();
      bookingSlotId =
          bottomNavController.notificationModel!.booking_slot_id.toString();
    }

    engine = createAgoraRtcEngineEx();

    checkPermissions();
  }

  Future<void> checkPermissions() async {
    bool cameraGranted = await requestCameraPermission();
    bool microphoneGranted = await requestMicrophonePermission();

    if (cameraGranted && microphoneGranted) {
      initData();
    } else {
      openSettingScreen();
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print("didChangeAppLifecycleState called" + callEndValue.toString());
      if (remoteUID.isEmpty) {
        print("didChangeAppLifecycleState called");
        leaveChannel();
        Get.back();
      } else if (callEndValue == 2) {
        callEndValue = 0;
        leaveChannel();
        Get.back();
      }
    }
  }

  Future<void> initData() async {
    _initEngine();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //channelId = sharedPreferences.getInt(SharePreferenceConst.user_id).toString() ?? '';
    //channelId = 'vteach';
    //channelId = 'iosvteach';
    //print("AAAAAAAAAAAAAA"+channelId);
  }

  Future<bool> requestCameraPermission() async {
    return await requestPermission(Permission.camera);
  }

  Future<bool> requestMicrophonePermission() async {
    return await requestPermission(Permission.microphone);
  }

  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      // Permission already granted
      return true;
    } else {
      // Request permission
      final result = await permission.request();

      if (result.isGranted) {
        // Permission granted
        return true;
      } else {
        // Permission denied
        return false;
      }
    }
  }

  void openSettingScreen() {
    showDialog<String>(
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppText.permission, style: blackPoppinsSemiBold20),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(AppText.need_to_give_permission,
                  style: blackPoppinsRegular18),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppText.open_setting),
            onPressed: () async {
              Get.back();
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    _dispose();
    super.onClose();
  }

  Future<void> _dispose() async {
    /* if(timer!.isActive){
      bottomNavController.callActionVCallService('call_end',start.value.toString());
    }*/
    WidgetsBinding.instance.removeObserver(this);
    engine.unregisterEventHandler(rtcEngineEventHandler);
    await engine.leaveChannel();
    await engine.release();
    timer?.cancel();
    await FlutterWindowManagerPlus.clearFlags(
        FlutterWindowManagerPlus.FLAG_SECURE);
  }

  void startTimer() {
    WakelockPlus.enable();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      start.value++;
      duration.value = _formatDuration(start.value);
      print('DURATION -->' + duration.value);
    });
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _initEngine() async {
    await engine.initialize(RtcEngineContext(
      appId: appId,
    ));
    rtcEngineEventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        print('RRRRRRRRRRR -->[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
        print(
            'RRRRRRRRRRR -->[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        if (connection.localUid == 11111) {
        } else {
          isJoined.value = true;
          await engine.setEnableSpeakerphone(true);
          startTimer();
        }
        // FlutterBackgroundService().startService();

/*        setState(() {
          isJoined = true;
        });*/
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        print(
            'RRRRRRRRRRR --> [onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        remoteUID.add(rUid);
      },
      onUserOffline: (RtcConnection connection, int rUid,
          UserOfflineReasonType reason) async {
        print(
            'RRRRRRRRRRR -->[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');

        if (connection.localUid == 11111) {
          callEndValue++;
        } else {
          callEndValue++;
        }

        if (rUid == 11111) {
          // engine.startPreview();
          // muteLocalVideoStream();
          await engine.enableLocalVideo(true); // Re-enable camera feed
          await engine.muteLocalVideoStream(false); // Ensure video is unmuted
          muteVideo.value = false;
        } else {
          remoteUID.removeWhere((element) => element == rUid);
        }
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        print(
            'RRRRRRRRRRR -->[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');

        if (connection.localUid == 11111) {
        } else {
          isJoined.value = false;
          remoteUID.clear();
          timer?.cancel(); // Stop the timer when the call ends
          start.value = 0;
          duration.value = "00:00";
        }
      },
      onRemoteVideoStateChanged: (RtcConnection connection, int remoteUid,
          RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
        print('AAAAAAAAAAA -->[onRemoteVideoStateChanged] Reason is: $reason');
        print('AAAAAAAAAAAA -->[onRemoteVideoStateChanged] State is : $state ');

        if (state == RemoteVideoState.remoteVideoStateStopped) {
          if (isScreenShare.value) {
            isUpdatingScreen.value = true;
            Future.delayed(Duration(milliseconds: 300), () {
              isUpdatingScreen.value = false; // End transition
            });
            muteVideo.value = true;
          } else {
            muteVideo.value = true;
          }
        }
        if (state == RemoteVideoState.remoteVideoStateStarting) {
          muteVideo.value = false;
        }

        if (state == RemoteVideoState.remoteVideoStateFrozen) {
          if (isLocalInternetOn.value == true) {
            isRemoteInternetOn.value = false;
            remoteInternetTimer = Timer(Duration(seconds: 20), () {
              callActionVCallService(
                  'call_end', start.value.toString(), "", "");
            });
          }
        }

        if (state == RemoteVideoState.remoteVideoStateDecoding) {
          if (isRemoteInternetOn.value == false) {
            isRemoteInternetOn.value = true;
            remoteInternetTimer!.cancel();
          }
        }
      },
      onLocalVideoStateChanged: (source, state, reason) {
        switch (state) {
          case LocalVideoStreamState.localVideoStreamStateCapturing:
            // when open screen share dialog called this
            print("VVVVVVVVVVVVVV -------- localVideoStreamStateCapturing");
          case LocalVideoStreamState.localVideoStreamStateEncoding:
            if (isScreenShare.value) {
              isScreenShareTemp.value = true;
            }
            break;
          case LocalVideoStreamState.localVideoStreamStateStopped:
          case LocalVideoStreamState.localVideoStreamStateFailed:
            // when cancel screen share from dialof called this
            print("VVVVVVVVVVVVVV -------- Screen sharing Stopeed");
            if (isScreenShare.value) {
              stopScreenShare();
            }
            break;
          default:
            break;
        }
      },
      onConnectionStateChanged: (connection, state, reason) {
        print(
            'AAAAAAAAAAAA -->[onConnectionStateChanged] ---- : state $state reason $reason ');
        if (reason ==
            ConnectionChangedReasonType.connectionChangedInterrupted) {
          print('AAAAAAAAAAAA --> local internet off');
          isLocalInternetOn.value = false;
          localInternetTimer = Timer(Duration(seconds: 20), () {
            Get.back();
          });
        }

        if (reason ==
            ConnectionChangedReasonType.connectionChangedRejoinSuccess) {
          print('AAAAAAAAAAAA --> local internet on');
          if (isLocalInternetOn.value == false) {
            isLocalInternetOn.value = true;
            localInternetTimer!.cancel();
          }
        }
      },
    );

    engine.registerEventHandler(rtcEngineEventHandler);

    await engine.enableVideo();
    await engine.startPreview();
    await engine.enableDualStreamMode(enabled: true);
    isEngineReady.value = true;
    joinChannel();
  }

  Future<void> joinChannel() async {
    if (!isEngineReady.value) return;
    await engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: int.parse(uid),
      options: ChannelMediaOptions(
        channelProfile: channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );

    print("RRRRRRRRRRRRRRRRRRRRRR ----> joinChannel");
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
    openCamera.value = true;
    muteCamera.value = false;
    muteAllRemoteVideo.value = false;
    WakelockPlus.disable();
    /*setState(() {
      openCamera = true;
      muteCamera = false;
      muteAllRemoteVideo = false;
    });*/
  }

  Future<void> switchCamera1() async {
    await engine.switchCamera();
    switchCamera.value = !switchCamera.value;
    /*setState(() {
      switchCamera = !switchCamera;
    });*/
  }

  Future<void> screenShare() async {
    isScreenShare.value = !isScreenShare.value;
  }

  openCamera1() async {
    await engine.enableLocalVideo(!openCamera.value);
    openCamera.value = !openCamera.value;
    /* setState(() {
      openCamera = !openCamera;
    });*/
  }

  muteLocalVideoStream() async {
    await engine.muteLocalVideoStream(!muteCamera.value);
    muteCamera.value = !muteCamera.value;
  }

  muteAllRemoteVideoStreams() async {
    await engine.muteAllRemoteVideoStreams(!muteAllRemoteVideo.value);
    muteAllRemoteVideo.value = !muteAllRemoteVideo.value;
    /*setState(() {
      muteAllRemoteVideo = !muteAllRemoteVideo;
    });*/
  }

  muteLocalAudio() async {
    await engine.muteLocalAudioStream(!muteAudio.value);
    muteAudio.value = !muteAudio.value;
    /*setState(() {
      muteCamera = !muteCamera;
    });*/
  }

  speakerOnOff() async {
    await engine.setEnableSpeakerphone(!speakerPhone.value);
    speakerPhone.value = !speakerPhone.value;
    /*setState(() {
      muteCamera = !muteCamera;
    });*/
  }

  void closeScreen() {
    //  FlutterBackgroundService().invoke('stopService');
    leaveChannel();
    Get.back();
  }

  // added new code
  Future<void> callActionVCallService(String status, String callDuration,
      String booking_id, String booking_slot_id) async {
    bookingId = booking_id;
    bookingSlotId = booking_slot_id;
    print("CALL CUT");
    print(bottomNavController.notificationModel!.booking_id.toString());
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['action_status'] = status;
      data['booking_id'] =
          bottomNavController.notificationModel!.booking_id.toString();
      data['booking_slot_id'] =
          bottomNavController.notificationModel!.booking_slot_id.toString();
      data['channel_id'] =
          bottomNavController.notificationModel!.channel_id.toString();
      data['app_unique_call_id'] =
          bottomNavController.notificationModel!.app_unique_call_id.toString();
      if (status == "call_end" || status == "time_completed") {
        data['call_duration'] = callDuration;
      }

      return data;
    }

    var apiService = _repository.sendPostApiRequest(
        toJson, action_vcall_notification, false);

    callDataService(
      apiService,
      onSuccess: (response) => successResponse(response, status),
      onError: handleOnError,
      isShowLoading: true,
    );
  }

  Future<void> successResponse(dynamic baseResponse, String status) async {
    BaseModel response = BaseModel.fromJson(baseResponse.data);
    if (response.success == true) {
      if (Platform.isIOS) {
        FlutterCallkitIncoming.endAllCalls();
      }
      // FlutterBackgroundService().invoke('stopService');
      if (status == "time_completed") {
        // onCompleteCallNew(bookingId,bookingSlotId);
      } else {
        leaveChannel();
        Get.back();
      }
    }
  }

  void handleOnError(dynamic e) {
    if (e is ApiException) {}
  }

  void cancelCallTimeout() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  void showAlertDialog(String alertMessage) {
    showDialog<String>(
        context: Get.context!,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                "Session End",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: Fonts.PoppinsMedium,
                    color: Clr.black),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      alertMessage,
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
                  },
                ),
              ],
            ));
  }

  Future<void> startScreenShare() async {
    if (!isScreenShare.value) {
      try {
        await engine.startScreenCapture(
          const ScreenCaptureParameters2(
            captureAudio: true,
            captureVideo: true,
          ),
        );
        await engine.joinChannelEx(
            token: token,
            connection: RtcConnection(
                channelId: channelName, localUid: screenShareTeacherUid),
            options: const ChannelMediaOptions(
              autoSubscribeVideo: true,
              autoSubscribeAudio: true,
              publishScreenTrack: true,
              publishSecondaryScreenTrack: true,
              publishCameraTrack: false,
              publishMicrophoneTrack: false,
              publishScreenCaptureAudio: true,
              publishScreenCaptureVideo: true,
              clientRoleType: ClientRoleType.clientRoleBroadcaster,
            ));
        isUpdatingScreen.value = true;
        isScreenShare.value = true;
        Future.delayed(Duration(milliseconds: 300), () {
          isUpdatingScreen.value = false; // End transition
        });
      } catch (e) {
        print("Error starting screen share: $e");
      }
    }
  }

  Future<void> stopScreenShare() async {
    if (isScreenShare.value) {
      try {
        // Stop the screen capture
        await engine.stopScreenCapture();

        // Leave the screen share channel
        await engine.leaveChannelEx(
          connection: RtcConnection(
            channelId: channelName,
            localUid: screenShareTeacherUid,
          ),
        );

        // Switch back to main channel with camera/mic
        await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

        // Enable local video preview
        await engine.enableLocalVideo(true);
        await engine.startPreview();

        // Update channel options to enable camera/mic and disable screen
        await engine.updateChannelMediaOptions(
          const ChannelMediaOptions(
            publishCameraTrack: true,
            publishMicrophoneTrack: true,
            publishScreenTrack: false,
            publishScreenCaptureAudio: false,
            publishScreenCaptureVideo: false,
            autoSubscribeAudio: true,
            autoSubscribeVideo: true,
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            enableAudioRecordingOrPlayout: true,
          ),
        );

        // Explicitly unmute video streams
        await engine.muteLocalVideoStream(false);
        await engine.muteAllRemoteVideoStreams(false);

        isUpdatingScreen.value = true;
        // Reset screen share state
        isScreenShare.value = false;
        isScreenShareTemp.value = false;
        Future.delayed(Duration(milliseconds: 300), () {
          isUpdatingScreen.value = false; // End transition
        });

        // Small delay to ensure everything is properly switched
        await Future.delayed(const Duration(milliseconds: 500));

        // Re-enable remote video receiving
        remoteUID.forEach((uid) async {
          await engine.muteRemoteVideoStream(mute: false, uid: uid);
        });
      } catch (e) {
        print("Error stopping screen share: $e");
      }
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

  void onCompleteCallNew(String bookingId, String bookingSlotId) {
    leaveChannel();
    Get.back();
    bottomNavController.showAlertDialogNew(bookingId, bookingSlotId);
  }
}
