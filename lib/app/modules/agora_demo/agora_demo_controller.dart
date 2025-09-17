import 'dart:async';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/comman_text.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../NotificationPayloadModel.dart';
import '../bottom__navigation_bar/BottomNavController.dart';
import '/app/core/base/base_controller.dart';

class AgoraDemoController extends BaseController with WidgetsBindingObserver {
  final ProjectRepository _repository =
      Get.find(tag: (ProjectRepository).toString());

  final emailController = TextEditingController();

  late final RtcEngineEx engine;

  RxBool isJoined = false.obs,
      isScreenShare = false.obs,
      isScreenShareTemp = false.obs,
      switchCamera = true.obs,
      switchRender = true.obs,
      openCamera = true.obs,
      muteCamera = false.obs,
      muteAudio = false.obs,
      muteVideo = false.obs,
      speakerPhone = true.obs,
      isEngineReady = false.obs,
      muteAllRemoteVideo = false.obs;
  Set<int> remoteUid = <int>{}.obs;
  RxBool isUseFlutterTexture = false.obs;
  bool isUseAndroidSurfaceView = true;
  ChannelProfileType channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  late final RtcEngineEventHandler rtcEngineEventHandler;
  final BottomNavController bottomNavController =
      Get.put(BottomNavController(), permanent: false);

  NotificationPayloadModel? notificationModel;
  RxString textEvents = "".obs;
  RxBool isCallEndByTeacher = false.obs;

  Timer? timer;
  RxInt start = 0.obs;
  RxInt callTimeout = 30.obs;
  RxString duration = "00:00".obs;
  Timer? callTimer;

  RxBool isApiCall = false.obs;
  RxBool isCallRunning = false.obs;

  String token = "";
  String channelName = "";
  String app_unique_call_id = "";
  String uid = "";
  String bookingId = "";
  String bookingSlotId = "";
  String studentName = "";
  String studentId = "";
  String profileImage = "";
  String appId = "";

  bool hasClosedScreen = false;

  AudioPlayer audioPlayer = AudioPlayer();

  int screenShareTeacherUid = 11111;
  var isUpdatingScreen = false.obs;
  static const platform = MethodChannel("com.example.app/native");

  String isFromList = "";

  RxBool isRemoteInternetOn = true.obs;
  RxBool isLocalInternetOn = true.obs;
  Timer? remoteInternetTimer;
  Timer? localInternetTimer;

  @override
  Future<void> onInit() async {
    super.onInit();
    token = Get.parameters['agora_token']!;
    channelName = Get.parameters['channel_name']!;
    app_unique_call_id = Get.parameters['app_unique_call_id']!;
    appId = Get.parameters['app_id']!;
    uid = Get.parameters['uid']!;
    bookingId = Get.parameters['booking_id']!;
    bookingSlotId = Get.parameters['booking_slot_id']!;
    studentName = Get.parameters['student_name']!;
    studentId = Get.parameters['student_id']!;
    profileImage = Get.parameters['profile_image']!;
    isFromList = Get.parameters['from_list']!;
    isApiCall.value = false;
    await _initEngine();
    isEngineReady.value = true;
    await joinChannel();
    startCallTimeout();
    WidgetsBinding.instance.addObserver(this);
    playOutgoingRingtone();
  }

  @override
  void onClose() {
    _dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (remoteUid.isEmpty) {
        print("didChangeAppLifecycleState called");
        leaveChannel();
        Get.back();
      }
    }
  }

  void startTimer() {
    WakelockPlus.enable();
    stopOutgoingRingtone();
    isCallRunning.value = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      start.value++;
      duration.value = _formatDuration(start.value);
    });
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    engine.unregisterEventHandler(rtcEngineEventHandler);
    await engine.leaveChannel();
    await engine.release();
    timer?.cancel();
    callTimer!.cancel();
    remoteInternetTimer?.cancel();
    localInternetTimer?.cancel();
    cancelCallTimeout();
    audioPlayer.dispose();
    await FlutterWindowManagerPlus.clearFlags(
        FlutterWindowManagerPlus.FLAG_SECURE);
  }

  Future<void> _initEngine() async {
    engine = createAgoraRtcEngineEx();
    await engine.initialize(RtcEngineContext(
      appId: appId,
    ));
    rtcEngineEventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        print('RRRRRRRRRRR -->[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        print(
            'RRRRRRRRRRR -->[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        isJoined.value = true;
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        print(
            'RRRRRRRRRRR --> [onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        if (remoteUid.isEmpty) {
          remoteUid.add(rUid);
          startTimer();
        }
      },
      onUserOffline: (RtcConnection connection, int rUid,
          UserOfflineReasonType reason) async {
        print(
            'RRRRRRRRRRR -->[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');

/*        if(reason == UserOfflineReasonType.userOfflineQuit){
          callActionVCallServiceTeacher('call_end');
        }*/

        if (rUid == 11111) {
          await engine.enableLocalVideo(true); // Re-enable camera feed
          await engine.muteLocalVideoStream(false); // Ensure video is unmuted
          muteVideo.value = false;
        } else {
          remoteUid.removeWhere((element) => element == rUid);
        }
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        print(
            'RRRRRRRRRRR -->[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        if (connection.localUid == 11111) {
        } else {
          isJoined.value = false;
          remoteUid.clear();
          engine.disableVideo();
          engine.disableAudio();
          engine.stopPreview();
          stopOutgoingRingtone();
        }
      },
      onRemoteVideoStateChanged: (RtcConnection connection, int remoteUid,
          RemoteVideoState state, RemoteVideoStateReason reason, int elapsed) {
        print(
            'AAAAAAAAAAA -->[onRemoteVideoStateChanged] Reason vvv is: $reason');
        print(
            'AAAAAAAAAAAA -->[onRemoteVideoStateChanged] State vvv is : $state ');
        print(
            'AAAAAAAAAAAA -->[onRemoteVideoStateChanged] Remote uid is ---- : $remoteUid ');

        if (state == RemoteVideoState.remoteVideoStateStopped) {
          if (isScreenShare.value) {
            isUpdatingScreen.value = true;
            muteVideo.value = true;
            Future.delayed(Duration(milliseconds: 300), () {
              isUpdatingScreen.value = false; // End transition
            });
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
              callActionVCallServiceTeacher('call_end');
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
          case LocalVideoStreamState.localVideoStreamStateEncoding:
            if (isScreenShare.value) {
              isScreenShareTemp.value = true;
            }
            break;
          case LocalVideoStreamState.localVideoStreamStateStopped:
          case LocalVideoStreamState.localVideoStreamStateFailed:
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
          publishScreenTrack: true),
    );
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
    openCamera.value = true;
    muteCamera.value = false;
    muteAllRemoteVideo.value = false;
    WakelockPlus.disable();
  }

  Future<void> switchCamera1() async {
    await engine.switchCamera();
    switchCamera.value = !switchCamera.value;
  }

  openCamera1() async {
    await engine.enableLocalVideo(!openCamera.value);
    openCamera.value = !openCamera.value;
  }

  muteLocalVideoStream() async {
    await engine.muteLocalVideoStream(!muteCamera.value);
    muteCamera.value = !muteCamera.value;
  }

  muteAllRemoteVideoStreams() async {
    await engine.muteAllRemoteVideoStreams(!muteAllRemoteVideo.value);
    muteAllRemoteVideo.value = !muteAllRemoteVideo.value;
  }

  muteLocalAudio() async {
    await engine.muteLocalAudioStream(!muteAudio.value);
    muteAudio.value = !muteAudio.value;
  }

  Future<void> callActionVCallServiceTeacher(String status) async {
    Map<String, dynamic> toJson() {
      print('TEACHER TO STUDENT CALL END');
      print(bookingId);
      final Map<String, dynamic> data = <String, dynamic>{};
      data['action_status'] = status;
      data['booking_id'] = bookingId;
      data['booking_slot_id'] = bookingSlotId;
      data['channel_id'] = channelName;
      data['app_unique_call_id'] = app_unique_call_id;
      if (status == "call_end" || status == "time_completed") {
        data['call_duration'] = start.value.toString();
      }
      return data;
    }

    var apiService = _repository.sendPostApiRequest(
        toJson, action_vcall_notification, false);

    callDataService(
      apiService,
      onSuccess: (response) => successResponseTeacher(response, status),
      onError: handleOnError,
      isShowLoading: true,
    );
  }

  Future<void> successResponseTeacher(
      dynamic baseResponse, String status) async {
    BaseModel response = BaseModel.fromJson(baseResponse.data);
    if (response.success == true) {
      if (status == "time_completed") {
      } else {
        if (Platform.isIOS) {
          FlutterCallkitIncoming.endAllCalls();
        }
        leaveChannel();
        Get.back();
      }
    }
  }

  Future<void> successResponse(dynamic baseResponse) async {
    BaseModel response = BaseModel.fromJson(baseResponse.data);
    if (response.success == true) {
      Get.back();
    }
  }

  void notificationData(NotificationPayloadModel model) {
    notificationModel = model;
    print('knjabfhjkabfjkabjkfbjkafb');
    if (Platform.isIOS) {
      bookingId = notificationModel!.booking_id.toString();
      bookingSlotId = notificationModel!.booking_slot_id.toString();
      channelName = notificationModel!.channel_id.toString();
    }
  }

  void closeCurrentScreen() {
    stopOutgoingRingtone();
    leaveChannel();
    Get.back();
  }

  void onCompleteCall(String isFromList) {
    leaveChannel();
    Get.back();
    bottomNavController.showAlertDialog(bookingId, bookingSlotId, isFromList);
  }

  void handleOnError(dynamic e) {
    if (e is ApiException) {}
  }

  speakerOnOff() async {
    await engine.setEnableSpeakerphone(!speakerPhone.value);
    speakerPhone.value = !speakerPhone.value;
  }

  void startCallTimeout() {
    callTimeout.value = 30;
    callTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (callTimeout.value > 0) {
        callTimeout.value--; // Decrement the countdown
        print("Time left: ${callTimeout.value} seconds");
      } else {
        timer.cancel(); // Stop the timer when it reaches 0
        // Trigger your timeout action here
        print("Timeout! Call timed out.");
        callActionVCallServiceTeacher("call_timeout");
      }
    });
  }

  void cancelCallTimeout() {
    if (callTimer != null && callTimer!.isActive) {
      callTimer!.cancel();
    }
  }

  void playOutgoingRingtone() async {
    await audioPlayer.play(AssetSource('images/outgoing_ringtone.mp3'));
  }

  // Method to stop the ringtone
  void stopOutgoingRingtone() async {
    await audioPlayer.stop();
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
        isScreenShare.value = false;
        isScreenShareTemp.value = false;
        Future.delayed(Duration(milliseconds: 300), () {
          isUpdatingScreen.value = false; // End transition
        });
        // Small delay to ensure everything is properly switched
        await Future.delayed(const Duration(milliseconds: 500));

        // Re-enable remote video receiving
        remoteUid.forEach((uid) async {
          await engine.muteRemoteVideoStream(mute: false, uid: uid);
        });
      } catch (e) {
        print("Error stopping screen share: $e");
      }
    }
  }

  void showAlertDialog(String alertMessage) {
    showDialog<String>(
        context: Get.context!,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                AppText.session_end,
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
}
