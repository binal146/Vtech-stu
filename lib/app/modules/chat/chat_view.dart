import 'package:advanced_icon/advanced_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/chat/chat_controller.dart';
import '../../core/hastager/widgets/hashtag_text_field.dart';
import '../../core/model/page_state.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../core/values/comman_text.dart';
import '../../core/widget/loading.dart';
import '/app/core/base/base_view.dart';
import 'chat_conversion_card.dart';

class ChatView extends BaseView<ChatController> {

  ChatView({super.key}) {
    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels == controller.scrollController.position.maxScrollExtent &&
          !controller.isLoading.value &&
          controller.hasMoreData.value) {
        controller.getConversation(offset: controller.messageList.length);
      }
    });
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  final _angle = 0.0.obs;

  double get angle => _angle.value;

  @override
  Widget body(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            backgroundColor: Clr.white,
            elevation: 0,
            titleSpacing: 0,
            leadingWidth: 45,
            title: GestureDetector(
              onTap: () {
              },
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(13),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              // "${controller.user.value?.firstName} ${controller.user.value?.lastName}",
                             // "${controller.user.value?.getFullName()}",
                              controller.studentName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: Fonts.PoppinsSemiBold,
                                  fontSize: 17,
                                  color: Clr.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Drawables.icBackSVG,
                onPressed: () {
                  Get.back();
                }),
          ),
          backgroundColor: Clr.white,
          body: Obx(() {
            return controller.messageListTemp.isNotEmpty
                ? ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ListView.builder(
                        shrinkWrap: false,
                        controller: controller.scrollController,
                        itemCount: controller.messageListTemp.length,
                        reverse: true,
                        physics: controller.pageState == PageState.LOADING
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var group = controller.messageListTemp[index];
                          return group.type == 'Header'
                              ? Padding(
                            padding: EdgeInsets.only(
                                bottom: 20),
                            child: Center(
                              child: Text(
                                // notificationData.group,
                                group.message ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: Fonts.PoppinsSemiBold,
                                    fontSize: 12,
                                    color: Clr.color434343),
                              ),
                            ),
                          )
                              : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.sp),
                            child: ChatConversionCard(
                              chatConversionModel: group,
                              user_id: controller.studentId,
                              chatConversionController: controller,
                              chat_id: group.toUserId.toString(),
                              index: index,
                            ),
                          );
                        }),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Center(
                        child: Obx(
                              () => controller.isRefresing.value
                              ?  CircularProgressIndicator()
                              :  SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
                : controller.isLoading.value && controller.messageList.isEmpty
                ? const Center(child: Loading())
                : buildEmptyState();
          }),
          bottomNavigationBar: SafeArea(
            child: (controller.isChatShow.value) ? Container(
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          color: Clr.colorF0F0F0,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                chooseFileOption(context);
                              },
                              child: SizedBox(
                                height: 45,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          16,
                                          0,
                                          0,
                                          2),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(0,
                                            2, 0, 0),
                                        child: AdvancedIcon(
                                          icon: Icons.add,
                                          secondaryIcon:
                                          Icons.cancel_rounded,
                                          color: Clr.color434343,
                                          effect: AdvancedIconEffect.spin,
                                          duration: const Duration(
                                              milliseconds: 200),
                                          state: controller.state.value,
                                          opacity: 0.8,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          12, 0, 0, 0),
                                      child: Text(
                                        '|',
                                        style: TextStyle(
                                          color: Clr.colorBFBFBF,
                                          fontFamily:
                                          Fonts.PoppinsRegular,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    6,
                                    0,
                                    12,
                                    2),
                                child: HashTagTextField(
                                  cursorColor: Clr.appColor,
                                  controller: controller.messageTextField,
                                  decoration: InputDecoration(
                                      hintText: AppText.writehere,
                                      hintStyle: TextStyle(
                                          fontSize: 13,
                                          fontFamily:
                                          Fonts.PoppinsRegular,
                                          color: Clr.colorBFBFBF),
                                      border: InputBorder.none),
                                  basicStyle: TextStyle(
                                      fontSize: 13,
                                      fontFamily: Fonts.PoppinsRegular,
                                      color: Clr.black),
                                  decoratedStyle: TextStyle(
                                      fontSize: 13,
                                      fontFamily: Fonts.PoppinsRegular,
                                      color: Clr.colorBFBFBF),
                                  keyboardType: TextInputType.multiline,
                                  textInputAction:
                                  TextInputAction.newline,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(
                                        r'^\s')), // Deny leading spaces
                                  ],
                                  onDetectionTyped: (text) {
                                    print("onDetectionType $text");
                                  },
                                  onChanged: (value) {},
                                  onEditingComplete: () {
                                    print("onEditingComplete");
                                  },
                                  onSubmitted: (value) {
                                    print("onSubmitted");
                                  },
                                  onDetectionFinished: () {},
                                  enableInteractiveSelection: true,
                                  minLines: 1,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 6),
                              child: GestureDetector(
                                  onTap: () {
                                    controller.validate();
                                  },
                                  child: Drawables.ic_chats_send_SVG),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ) : SizedBox()
          ),
        );
      }),
    );
  }

  buildEmptyState() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              controller.isLoading.value = false;
              controller.currentPage = 1;
              controller.hasMoreData.value = true;
              controller.getConversation();
            },
            child: Icon(
              Icons.refresh,
              size: 24.sp,
            ),
          ),
          const Text(
            AppText.conversionNotAdded,
            style: TextStyle(fontFamily: Fonts.PoppinsRegular),
          ),
        ],
      ),
    );
  }


  void chooseFileOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding:  EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          child: Wrap(  // Wrap allows dynamic height adjustment
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        controller.pickImage();
                        Get.back();
                      },
                      child: Text(AppText.select_image),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        controller.pickPdf();
                        Get.back();
                      },
                      child: Text(AppText.select_file),
                    ),
                  ],),
              )
            ],
          ),
        );
      },
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // No glow effect
  }
}

