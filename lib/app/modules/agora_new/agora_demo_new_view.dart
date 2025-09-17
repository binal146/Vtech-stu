import 'dart:ui';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import 'package:get/get.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../example_actions_widget.dart';
import '../../routes/app_pages.dart';
import '/app/core/base/base_view.dart';
import 'agora_demo_new_controller.dart';

class AgoraDemoNewView extends BaseView<AgoraDemoNewController>  {

  AgoraDemoNewView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    secureScreen();
    return PopScope(
      canPop: false,
      child: ExampleActionsWidget(
        displayContentBuilder: (context, isLayoutHorizontal) {

          return Stack(
            children: [

              Obx(() {

                if(controller.isUpdatingScreen.value){
                  return SizedBox();
                }

                return (controller.remoteUID.isNotEmpty)
                    ?  (controller.muteVideo.value == false) ? AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: controller.engine,
                    canvas: VideoCanvas(uid: controller.remoteUID.first),
                    connection: RtcConnection(channelId: controller.channelName),
                    useFlutterTexture: false,
                    useAndroidSurfaceView: controller.isUseAndroidSurfaceView,
                  ),
                ) : Container(
                  color: Colors.black54,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.teacherName.value,
                          style: TextStyle(
                            color: Clr.white,
                            fontSize: 20.sp,
                            fontFamily: Fonts.PoppinsMedium,
                          ),
                        ),
                        SizedBox(height: 10.h,),
                        (controller.teacherProfile!.isEmpty) ? Padding(
                            padding: EdgeInsets.all(20),
                            child: SvgPicture.asset(Drawables.user_add,height: 30.h,width: 30.w,)) : ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.network(controller.teacherProfile.value,fit: BoxFit.cover,height: 100.h,width: 100.w,))
                      ],
                    ),
                  ),
                )
                    : Center(
                  child: Text(
                    'Waiting for remote user...',
                    style: TextStyle(color: Clr.white, fontSize: 16.sp),
                  ),
                );
              }),

              // Display your own video as a small overlay
              Positioned(
                top: 16,
                right: 16,
                child: SizedBox(
                  width: 100.w, // Adjust width as needed
                  height: 150.h, // Adjust height as needed
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: controller.engine,
                      canvas: VideoCanvas(uid: 0),
                      useFlutterTexture: controller.isUseFlutterTexture.value,
                      useAndroidSurfaceView: controller.isUseAndroidSurfaceView,
                    ),
                    onAgoraVideoViewCreated: (viewId) {
                      controller.engine.startPreview();
                    },
                  ),
                ),
              ),

              // Bottom control buttons
              bottomWidget(),

              Obx(() => (controller.isRemoteInternetOn.value == false) ? Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.2), // Add semi-transparent overlay
                  ),
                ),
              ) : SizedBox(),),

              Obx(() => (controller.isRemoteInternetOn.value == false) ? Center(
                child: Text(
                  'reconnection',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: Fonts.PoppinsRegular,
                  ),
                ),
              ) : SizedBox(),),

              Obx(() => ((controller.remoteUID.isNotEmpty)) ? Align(
                alignment: Alignment.topCenter,
                child: Text(controller.duration.value.toString(),style: TextStyle(
                    color: Clr.white,fontSize: 16.sp,fontFamily: Fonts.PoppinsMedium
                ),),
              ) : SizedBox(),)

            ],
          );
        },
      ),
    );
  }
  
  Widget bottomWidget(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).size.width * 0.2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                controller.callActionVCallService('call_end',controller.start.value.toString(),"","");
              },
              child: Container(
                height: 60.h,
                width: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Clr.redDark,
                ),
                child: Icon(
                  Icons.call_end,
                  color: Clr.white,
                  size: 30.sp,
                ),
              ),
            ),

            SizedBox(height: 10.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                InkWell(
                  onTap: () {
                    controller.switchCamera1();
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Clr.white,
                    ),
                    child: SvgPicture.asset(Drawables.switch_camera, height: 20.h, width: 20.w),
                  ),
                ),
                Obx(() {
                  bool isEnabled = !controller.isScreenShare.value;

                  return IgnorePointer(
                    ignoring: !isEnabled, // Ignore pointer events when disabled
                    child: Opacity(
                      opacity: isEnabled ? 1.0 : 0.5,
                      child: InkWell(
                        onTap: () {
                          if (isEnabled) {
                            controller.muteLocalVideoStream();
                          }
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.w,
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Clr.white,
                          ),
                          child: Obx(() => controller.muteCamera.value
                              ? SvgPicture.asset(Drawables.video_off, width: 20.w, height: 20.h)
                              : SvgPicture.asset(Drawables.video_on, width: 20.w, height: 20.h)),
                        ),
                      ),
                    ),
                  );
                }),

                InkWell(
                  onTap: () {
                    controller.speakerOnOff();
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Clr.white,
                    ),
                    child: Obx(() => controller.speakerPhone.value
                        ? SvgPicture.asset(Drawables.volume_on, width: 20.w, height: 20.h)
                        : SvgPicture.asset(Drawables.volume_off, width: 20.w, height: 20.h)),
                  ),
                ),

                InkWell(
                  onTap: () {
                    controller.muteLocalAudio();
                  },
                  child:  Container(
                    height: 40.h,
                    width: 40.w,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Clr.white,
                    ),
                    child: Obx(() => controller.muteAudio.value
                        ? SvgPicture.asset(Drawables.mute_off, width: 20.w, height: 20.h)
                        : SvgPicture.asset(Drawables.mute_on, width: 20.w, height: 20.h)),
                  ),
                ),

                InkWell(
                  onTap: () {
                    if(controller.isScreenShare.value){
                      controller.stopScreenShare();
                    } else{
                      controller.startScreenShare();
                    }
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Clr.white,
                    ),
                    child: Obx(() => controller.isScreenShareTemp.value
                        ? Icon(Icons.screen_share_outlined , size: 22,)
                        : Icon(Icons.stop_screen_share_outlined,size: 22,)),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.CHAT,parameters: {
                      'student_id' : controller.studentId,
                      'booking_id' : controller.bookingId,
                      'booking_slot_id' : controller.bookingSlotId,
                      'student_name' : controller.teacherName.toString(),
                    });
                  },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Clr.white,
                    ),
                    child: Icon(Icons.chat , size: 22,),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  void secureScreen() async {
    await FlutterWindowManagerPlus.addFlags(FlutterWindowManagerPlus.FLAG_SECURE);
  }

}


