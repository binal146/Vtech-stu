import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vteach_teacher/app/modules/chat/chat_controller.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/utils/image.dart';
import '../../routes/app_pages.dart';
import 'model/ChatModelData.dart';
import 'model/PetMediaModel.dart';

class ChatConversionCard extends StatelessWidget {
  ChatConversionCard(
      {super.key,
      required this.chatConversionModel,
      required this.user_id,
      required this.chatConversionController,
      required this.chat_id,
      required this.index});

  ChatModelData chatConversionModel;
  ChatController chatConversionController;
  String user_id;
  String chat_id;
  int index;
  RxList<AssetEntity> profilePic = <AssetEntity>[].obs;
  List<PetMediaModel> pickedFileList = <PetMediaModel>[].obs;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onLongPress: () async {
       /* if (user_id == chatConversionModel.id?.toString()) {
          final results = await alertSingleChatMessage(
              context,
              "Delete chat message",
              "Delete for everyone",
              "Delete for me");
          if (results != null) {
            chatConversionController.selectedPos = index;
            //chatConversionController.deleteChatConversaction(chat_id, results);
          }
        } else {
          final results = await alertSingleChatMessage(
              context, "Delete chat message", "yes", "no");
          if (results != null && results == 1) {
            chatConversionController.selectedPos = index;
            //chatConversionController.deleteChatConversaction(chat_id, 0);
          }
        }*/
      },
      child: user_id == chatConversionModel.toUserId.toString()
          ? Align(
              alignment: Alignment.centerRight,
              child: conversionWithSender(chatConversionModel))
          : Align(
              alignment: Alignment.centerLeft,
              child: conversionWithReceiver(chatConversionModel)),
    );
  }

  Column conversionWithSender(ChatModelData? chatConvLists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(left: 30.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Clr.colorF0F0F0),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10),
            child: chatConvLists?.messageType == 'text'
                ? ExpandableText(
                    '${chatConvLists?.message}',
                    expandText: 'show more',
                    collapseText: 'show less',
                    maxLines: 8,
                    linkColor: Colors.blue,
                    animation: true,
                    collapseOnTextTap: false,
                    prefixText: "",
                    onPrefixTap: () {},
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Fonts.PoppinsRegular,
                        //fontFamilyFallback: const [Fonts.NOTOEMOJI],
                        color: Clr.C_434343),
                    prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
                    onHashtagTap: (hasTag) {},
                    hashtagStyle: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: Fonts.PoppinsRegular,
                       // fontFamilyFallback: const [Fonts.NOTOEMOJI],
                        color: Clr.C_434343),
                    onMentionTap: (value) {
                      print(value);
                    },
                    mentionStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    onUrlTap: (url) async {
                      if (url.startsWith("www")) {
                        url = "http://$url";
                      }
                      if (!await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      )) {
                        throw Exception('Could not launch $url');
                      }
                    },
                    urlStyle: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  )
                : chatConvLists?.messageType == 'pdf' ? GestureDetector(
                    onTap: () {
                  /*    Get.toNamed(Routes.IMAGEVIDEO,
                          arguments: chatConvLists.media);*/

                      if(chatConvLists.messageType == "pdf") {
                        Get.toNamed(Routes.VIEW_PDF, parameters: {
                          'pdf_title': chatConvLists.fileName.toString(),
                          "file_url": chatConvLists.fileImagePath.toString()
                        });
                      }
                    },
                    child: SizedBox(
                      width: 100.sp,
                      child: Stack(
                        children: [
                          chatConvLists!.fileImagePath!.isNotEmpty
                              ? Center(
                                child: Column(
                                  children: [
                                    SvgPicture.asset(Drawables.pdf_document),

                                    SizedBox(height: 5.h,),

                                    Text(chatConvLists!.fileName.toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                        color: Clr.blackColor,
                                        fontFamily: Fonts.PoppinsRegular),),
                                  ],
                                ),
                              )
                              :  SizedBox(
                                  child: Center(
                                      child: Icon(
                                    Icons.error,
                                    size: 100,
                                  )),
                                ),
                        ],
                      ),
                    ),
                  ) :
    chatConvLists?.messageType == 'document' ? GestureDetector(
      onTap: () {
        if(chatConvLists.messageType == "document") {
          chatConversionController.downloadFile(chatConvLists.fileImagePath.toString(), chatConvLists.fileName.toString());
        }
      },
      child: SizedBox(
        width: 100.sp,
        child: Stack(
          children: [
            chatConvLists!.fileImagePath!.isNotEmpty
                ? Center(
              child: Column(
                children: [
                  SvgPicture.asset(Drawables.document),

                  SizedBox(height: 5.h,),

                  Text(chatConvLists!.fileName.toString(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 8.sp,
                        color: Clr.blackColor,
                        fontFamily: Fonts.PoppinsRegular),),
                ],
              ),
            )
                :  SizedBox(
              child: Center(
                  child: Icon(
                    Icons.error,
                    size: 100,
                  )),
            ),
          ],
        ),
      ),
    ) : GestureDetector(
              onTap: () {
                Get.toNamed(Routes.VIEW_IMAGE, parameters: {
                  "file_url": chatConvLists.fileImagePath.toString()
                });
              },
              child: SizedBox(
                height: 100.sp,
                width: 100.sp,
                child: Stack(
                  children: [
                    chatConvLists!.fileImagePath!.isNotEmpty
                        ? AspectRatio(
                      aspectRatio: 1 / 1,
                      child: CachedNetworkImage(
                          errorWidget: (context, url, error) =>
                              Icon(Icons.person),
                          fit: BoxFit.fill,
                          imageUrl: chatConvLists
                              .fileImagePath ??
                              ""),
                    )
                        : const SizedBox(
                      child: Center(
                          child: Icon(
                            Icons.error,
                            size: 100,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: Text(
            convertStringTime(
              chatConvLists?.createdAt.toString() ?? "",
            ),
            style: TextStyle(
                fontFamily: Fonts.PoppinsRegular,
                //fontFamilyFallback: const [Fonts.NOTOEMOJI],
                fontSize: 11,
                color: Clr.colorAAAAAA),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  Column conversionWithReceiver(ChatModelData? chatConvLists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(right: 30.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: Clr.colorFFF1E8),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10),
            child: chatConvLists?.messageType == 'text'
                ?
            ExpandableText(
              '${chatConvLists?.message}',
              expandText: 'show more',
              collapseText: 'show less',
              maxLines: 8,
              linkColor: Colors.blue,
              animation: true,
              collapseOnTextTap: false,
              prefixText: "",
              onPrefixTap: () {},
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: Fonts.PoppinsRegular,
                  //fontFamilyFallback: const [Fonts.NOTOEMOJI],
                  color: Clr.color434343),
              prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
              onHashtagTap: (hasTag) {},
              hashtagStyle: TextStyle(
                  fontSize: 12,
                  fontFamily: Fonts.PoppinsRegular,
                  //fontFamilyFallback: const [Fonts.NOTOEMOJI],
                  color: Clr.color434343),
              onMentionTap: (value) {
                print(value);
              },
              mentionStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              onUrlTap: (url) async {
                if (url.startsWith("www")) {
                  url = "http://$url";
                }
                if (!await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch $url');
                }
              },
              urlStyle: const TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue),
            )
                : chatConvLists?.messageType == 'pdf' ? GestureDetector(
              onTap: () {
                /*    Get.toNamed(Routes.IMAGEVIDEO,
                          arguments: chatConvLists.media);*/

                if(chatConvLists.messageType == "pdf") {
                  Get.toNamed(Routes.VIEW_PDF, parameters: {
                    'pdf_title': chatConvLists.fileName.toString(),
                    "file_url": chatConvLists.fileImagePath.toString()
                  });
                }
              },
              child: SizedBox(
                width: 100.sp,
                child: Stack(
                  children: [
                    chatConvLists!.fileImagePath!.isNotEmpty
                        ? Center(
                      child: Column(
                        children: [
                          SvgPicture.asset(Drawables.pdf_document),

                          SizedBox(height: 5.h,),

                          Text(chatConvLists!.fileName.toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 8.sp,
                                color: Clr.blackColor,
                                fontFamily: Fonts.PoppinsRegular),),
                        ],
                      ),
                    )
                        :  SizedBox(
                      child: Center(
                          child: Icon(
                            Icons.error,
                            size: 100,
                          )),
                    ),
                  ],
                ),
              ),
            ) :
            chatConvLists?.messageType == 'document' ? GestureDetector(
              onTap: () {
                if(chatConvLists.messageType == "document") {
                  chatConversionController.downloadFile(chatConvLists.fileImagePath.toString(), chatConvLists.fileName.toString());
                }
              },
              child: SizedBox(
                width: 100.sp,
                child: Stack(
                  children: [
                    chatConvLists!.fileImagePath!.isNotEmpty
                        ? Center(
                      child: Column(
                        children: [
                          SvgPicture.asset(Drawables.document),

                          SizedBox(height: 5.h,),

                          Text(chatConvLists!.fileName.toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 8.sp,
                                color: Clr.blackColor,
                                fontFamily: Fonts.PoppinsRegular),),
                        ],
                      ),
                    )
                        :  SizedBox(
                      child: Center(
                          child: Icon(
                            Icons.error,
                            size: 100,
                          )),
                    ),
                  ],
                ),
              ),
            ) : GestureDetector(
              onTap: () {
                Get.toNamed(Routes.VIEW_IMAGE, parameters: {
                  "file_url": chatConvLists.fileImagePath.toString()
                });
              },
              child: SizedBox(
                height: 100.sp,
                width: 100.sp,
                child: Stack(
                  children: [
                    chatConvLists!.fileImagePath!.isNotEmpty
                        ? AspectRatio(
                      aspectRatio: 1 / 1,
                      child: CachedNetworkImage(
                          errorWidget: (context, url, error) =>
                              Icon(Icons.person),
                          fit: BoxFit.fill,
                          imageUrl: chatConvLists
                              .fileImagePath ??
                              ""),
                    )
                        : const SizedBox(
                      child: Center(
                          child: Icon(
                            Icons.error,
                            size: 100,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),

        // ClipRRect(
        //     borderRadius: BorderRadius.circular(AppValues.setValue_17),
        //     child: Image.asset(ImageIconName.myProfilePNG)),
        // SizedBox(
        //   height: AppValues.setValue_12,
        // ),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            convertStringTime(
              chatConvLists?.createdAt.toString() ?? "",
            ),
            style: TextStyle(
                fontFamily: Fonts.PoppinsRegular,
                fontSize: 11,
                color: Clr.colorAAAAAA),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  static Future<int?> alertSingleChatMessage(BuildContext context,
      String? message, String positive, String negative) async {
    Completer<int?> completer = Completer<int?>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "Alert",
              style: TextStyle(
                  fontFamily: Fonts.PoppinsMedium,
                  fontSize: 17,
                  color: Clr.black),
            ),
            content: Text(
              '$message',
              style: TextStyle(
                  fontFamily: Fonts.PoppinsRegular,
                  fontSize: 14,
                  color: Clr.black),
            ),
            actions: <Widget>[
              TextButton(
                child: Center(
                  child: Text(
                    positive,
                    style: TextStyle(
                      fontFamily: Fonts.PoppinsBold,
                      fontSize: 14,
                      color: Clr.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  completer.complete(1); // Set the completer value
                },
              ),
              TextButton(
                child: Center(
                  child: Text(
                    negative,
                    style: TextStyle(
                      fontFamily: Fonts.PoppinsBold,
                      fontSize: 14,
                      color: Clr.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  completer.complete(0); // Set the completer value
                },
              )
            ],
          );
        },
      );
    });
    return completer.future; // Return the future value from the completer
  }

  static String convertStringTime(String dateTime) {
    if (dateTime.isNotEmpty) {
      // Set the local time zone

      // Parse the UTC time string
      final parsedDate =
      DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime, true);

      // Convert UTC to the specified time zone

      // Format the time in the specified time zone
      final formattedTimeInTimeZone = DateFormat('hh:mm a').format(parsedDate);

      return formattedTimeInTimeZone;
    }
    return ''; // Return an empty string for invalid input
  }


}
