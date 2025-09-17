import 'dart:async';
import 'dart:collection';
import 'package:advanced_icon/advanced_icon.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vteach_teacher/app/core/utils/common_widgets.dart';
import 'package:vteach_teacher/app/modules/chat/model/ChatModel.dart';
import 'package:vteach_teacher/app/modules/chat/model/SendMessageModel.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/fonts.dart';
import '../../core/values/comman_text.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/not_found_exception.dart';
import '../appointment_detail/model/AppointmentData.dart';
import '/app/core/base/base_controller.dart';
import 'model/ChatModelData.dart';
import 'model/PetMediaModel.dart';
import 'package:dio/dio.dart' as MULTI;

class ChatController extends BaseController  with WidgetsBindingObserver {

  Rx<bool> isUploadMedia = Rx<bool>(false);
  Rx<double> rotationAngle = Rx<double>(0);
  Rx<bool> showCloseIcon = Rx<bool>(false);

  Rx<AdvancedIconState> state =
  Rx<AdvancedIconState>(AdvancedIconState.primary);
  final messageTextField = TextEditingController();
  Queue<String> videoQueue = Queue();

  RxList<ChatModelData> messageList = RxList<ChatModelData>();
  RxList<ChatModelData> messageListTemp = RxList<ChatModelData>();


  ScrollController scrollController = ScrollController();
  Rx<bool> isRefresing = Rx<bool>(false);
  Rx<bool> isLongPressed = Rx<bool>(false);

  int selectedPos = -1;
  Rx<int> muteAndUnMuteSelectIndex = Rx<int>(0);
  Rx<int> isBlockUser = Rx<int>(0);
  RxList<AssetEntity> profilePic = <AssetEntity>[].obs;

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());
  RxString noDataMessage = "".obs;

  var isLoading = false.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;
  final int pageSize = 25;

  List<PetMediaModel> pickedFileList = <PetMediaModel>[].obs;

  late var bookingData = Rxn<AppointmentData>();

  var image = Rx<XFile?>(null);

  var selectedImage = Rx<XFile?>(null);
  final ImagePicker picker = ImagePicker();
  
  String studentId = "";
  String bookingId = "";
  String bookingSlotId = "";
  String studentName = "";


  RxBool isChatShow = false.obs;


  @override
  Future<void> onInit() async {
    super.onInit();
    if(Get.arguments != null){
      bookingData.value = Get.arguments;
      studentId = bookingData.value!.student_id.toString();
      bookingId = bookingData.value!.bookingId.toString();
      bookingSlotId = bookingData.value!.bookingSlotId.toString();
      studentName = bookingData.value!.studentName.toString();
    } else {
      studentId = Get.parameters['student_id']!;
      bookingId = Get.parameters['booking_id']!;
      bookingSlotId = Get.parameters['booking_slot_id']!;
      studentName = Get.parameters['student_name']!;
    }
    
    getConversation();
  }


  Future<void> getConversation({int offset = 0}) async {
    if (offset == 0) {
      messageList.clear();
    }

    if (!isLoading.value && hasMoreData.value) {
      isLoading.value = true;

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['offset'] = offset;
        data['to_user_id'] = studentId;
        data['booking_id'] = bookingId;
        data['booking_slot_id'] = bookingSlotId;
        return data;
      }

      var apiService = _repository.sendGetApiWithParamRequest(toJson, get_conversation, false);

      await callDataService(
        apiService,
        onSuccess: (baseResponse) => successResponseConversation(baseResponse, offset),
        onError: (baseError) => handleOnErrorConversation(baseError, offset),
        isShowLoading: (offset == 0) ? false : false,
      );

      isLoading.value = false;
    }
  }

  Future<void> successResponseConversation(dynamic baseResponse, int offset) async {
    ChatModel response = ChatModel.fromJson(baseResponse.data);

    if (response.success == true) {
      isCompleted5Minutes(response.date.toString(), response.time.toString());
      if (response.data!.length < pageSize) {
        hasMoreData.value = false; // No more data to load
      }

      if (offset == 0) {
        messageList.assignAll(response.data!); // First page load
      } else {
        messageList.addAll(response.data!); // Append for pagination
      }
      setMessage();
    }
  }

  void handleOnErrorConversation(dynamic e,int offset) {
    if (e is NotFoundException) {
      noDataMessage.value = e.response_msg;
      if(offset == 0) {
        messageList.clear();
      }
      hasMoreData.value = false;
    }
  }

  void validate() {
    String? errorMessage;

    if (messageTextField.text.isEmpty) {
      errorMessage = AppText.write_your_msg_here;
    }
    if (isValid(errorMessage ?? "") != true) {
      sendMessage(messageTextField.text, "","");
    } else {
      snackMessage(errorMessage.toString());
    }
  }

  static bool isValid(String str) {
    if (str == "" || str == " " || str == "(null)" || str.trim() == "") {
      return false;
    }
    return true;
  }

  static void snackMessage(String message) {
    ScaffoldMessenger.of(Get.context as BuildContext).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1),
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.yellow),
            SizedBox(
              width: 5.sp,
            ),
            Expanded(
                child: Text(
                  message,
                  style:
                  TextStyle(fontSize: 10.sp, fontFamily: Fonts.PoppinsMedium),
                  maxLines: 3,
                )),
          ],
        )));
  }

  Future<void> onRefresh() async {
    currentPage = 1;
    getConversation();
  }

  static void warningToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Clr.white,
      timeInSecForIosWeb: 2,
    );
  }

  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf','doc'],
    );

    if (result != null) {
      image.value = XFile(result.files.single.path!);
    } else {
      // User canceled the picker
    }

    if (image != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        sendMessage("", image.value!.path.toString(),image.value!.name.toString());
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = XFile(pickedFile.path);

      Future.delayed(const Duration(milliseconds: 100), () {
        sendMessage("", selectedImage.value!.path.toString(),selectedImage.value!.name.toString());
      });
    }
  }

  Future<void> sendMessage(String message, String mediaFile,String mediaName) async {

      Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data["to_user_id"] = studentId;
        data["booking_id"] = bookingId;
        data["booking_slot_id"] = bookingSlotId;
        if(mediaFile.isNotEmpty) {
          data["message_type"] = "image";
        } else{
          data["message_type"] = "text";
          data["message"] = message;
        }
        if(mediaFile.isNotEmpty) {
          // MultipartFile file= await MultipartFile.fromFile(image!.path, filename: image.name)
          MULTI.MultipartFile file = MULTI.MultipartFile.fromFileSync(mediaFile, filename: mediaName);
          data['file'] = file;
        }
        return data;
      }

      var apiService = _repository.sendPostApiRequest(toJson, send_message, false);

      await callDataService(
        apiService,
        onSuccess: (baseResponse) => successResponseSendMessage(baseResponse),
        onError: (baseError) => handleOnErrorSendMessage(baseError),
        isShowLoading: true,
      );

  }

  Future<void> successResponseSendMessage(dynamic baseResponse) async {
    SendMessageModel response = SendMessageModel.fromJson(baseResponse.data);

    if (response.success == true) {
      profilePic.clear();
      hideLoading();
      messageTextField.text = "";
      dynamic message = response.data;
      messageList.insert(0, message);

      // allMessageList.clear();
      setMessage();

      // allMessageList.addAll(groupMessagesByDate());
      _smoothScrollToTop();
      currentPage = messageList.length;
    }

  }

  void _smoothScrollToTop() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  void handleOnErrorSendMessage(dynamic e) {
    if (e is NotFoundException) {
      CommonUtils.getIntance().toastMessage(e.response_msg.toString());
    }
  }

  void setMessage() {
    messageListTemp.clear();

    messageListTemp.addAll(messageList);

    String dateTime = "";
    final myFormat = DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US');
    final formatter = DateFormat('yyyy-MM-dd');
    for (int i = messageList.length - 1; i >= 0; i--) {
      String messageDate = formatter.format(myFormat.parse(messageList[i].createdAt.toString()));

      if (messageList[i].message != null &&
          messageDate.isNotEmpty &&
          messageDate != dateTime) {
        ChatModelData model = ChatModelData();
        model.type = "Header";
        model.message = getDate(messageDate);

        messageListTemp.insert(i + 1, model);

        dateTime = formatter
            .format(myFormat.parse(messageList[i].createdAt.toString()));
      }
    }
  }

  String getDate(String date) {
    final formatter = DateFormat('yyyy-MM-dd');
    DateTime someDate = formatter.parse(date);

    if (isToday(someDate)) {
      return "Today";
    } else if (isYesterday(someDate)) {
      return "Yesterday";
    } else {
      return DateFormat('dd MMMM yyyy').format(someDate);
    }
  }

  bool isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool isYesterday(DateTime date) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  void receivedNewMessage(ChatModelData chatModelData){
    messageList.insert(0, chatModelData);
    setMessage();
    _smoothScrollToTop();
    currentPage = messageList.length;
  }

  Future<String> downloadFile(String url, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$fileName';

    final response = await Dio().download(url, filePath);
    if (response.statusCode == 200) {
      openDocument(filePath);
      return filePath;
    } else {
      throw Exception('Failed to download file');
    }
  }

  void openDocument(String filePath) async {
    try {
      final result = await OpenFilex.open(filePath);
      CommonUtils.getIntance().toastMessage(result.message);
    } catch (e) {
      print('Error opening file: $e');
    }
  }

  void isCompleted5Minutes(String sessionDate,String sessionTime) {
    String date = sessionDate;
    String time = sessionTime;
    String endTime = getLastTime(time);

    // Parse the date and time
    DateTime parsedDateTime = parseDateTime(date, endTime);

    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the time after 5 minutes from the specified time
    DateTime triggerTime = parsedDateTime.add(Duration(minutes: 5));

    // Calculate the difference
    Duration delay = triggerTime.difference(now);

    // If the time has already passed, execute immediately
    if (delay.isNegative) {
      isChatShow.value = false;
    } else {
      isChatShow.value = true;
      Timer(delay, () {
        isChatShow.value = false;
      });
    }
  }

  String getLastTime(String time) {
    List<String> timeParts = time.split('-');

    return timeParts.last.trim();
  }

  DateTime parseDateTime(String date, String time) {
    String formattedTime = convertTo24HourFormat(time);
    String formattedDateTime = "$date $formattedTime";
    return DateTime.parse(formattedDateTime);
  }

  String convertTo24HourFormat(String time) {
    final timeParts = time.split(" ");
    final period = timeParts[1].toUpperCase(); // AM or PM
    final timeWithoutPeriod = timeParts[0];
    final hoursMinutes = timeWithoutPeriod.split(":");
    int hours = int.parse(hoursMinutes[0]);
    final minutes = hoursMinutes[1];

    if (period == "PM" && hours != 12) {
      hours += 12;
    } else if (period == "AM" && hours == 12) {
      hours = 0;
    }
    return "${hours.toString().padLeft(2, '0')}:$minutes:00";
  }
}


