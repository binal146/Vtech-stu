import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vteach_teacher/app/modules/UploadDocumentModel.dart';
import '../../core/base/BaseModel.dart';
import '../../core/utils/api_services.dart';
import '../../core/utils/colour.dart';
import '../../core/utils/common_widgets.dart';
import '../../core/values/comman_text.dart';
import '../../data/repository/project_repository.dart';
import '../../network/exceptions/api_exception.dart';
import '../my_profile/model/Document.dart';
import '/app/core/base/base_controller.dart';

class AddDocumentController extends BaseController {

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());

  var textfieldControllers = <TextEditingController>[].obs;
  var images = <XFile?>[].obs;
  final ImagePicker picker = ImagePicker();
  RxList<Document>? documentListTemp = <Document>[].obs;
  RxList<Document>? documentList = <Document>[].obs;
  List<UploadDocumentModel>? uploadedDocumentsList = <UploadDocumentModel>[].obs;
  List<Map<String, dynamic>> uploadedDocuments = [];
  RxBool isAdd = false.obs;
  List<String> deletedDocumentsList = [];
  RxBool isDataUpdate = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    if(Get.arguments != null){
      isAdd.value = false;
      documentListTemp!.value = Get.arguments;
      documentList!.value = documentListTemp!.map((model) => Document.copy(model)).toList();
      for(var document in documentList!){
        addMultipleFields(document,false);
      }
    }else{
      isAdd.value = true;
      addMoreDocuments();
    }

  }

  @override
  void dispose() {
    for (var controller in textfieldControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addMultipleFields(Document document,bool isAddMore) {
    textfieldControllers.add(TextEditingController(text: document.title));
    images.add(null);
    if(isAddMore){
      documentList!.value.add(document);
    }
    print("Images list is -->"+document.fileUrl.toString());
  }

  Future<void> pickImage(int index) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
        images[index] = XFile(pickedFile.path);
    }
  }

  Future<void> pickPdf(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      images[index] = XFile(result.files.single.path!);
    } else {
      // User canceled the picker
    }
  }

  void getSavedData(){
    uploadedDocumentsList!.clear();
    for(int i = 0; i<images.length; i++){
      if(images[i] != null){
        uploadedDocumentsList!.add(UploadDocumentModel(documentList![i].id!,textfieldControllers[i]!.value.text, images[i]!));
      } else {
        if(textfieldControllers[i].value.text == documentList![i].title) {
        }else{
          uploadedDocumentsList!.add(UploadDocumentModel(documentList![i].id!, textfieldControllers[i].value.text, null));
        }
      }
    }
    List<Map<String, dynamic>> uploadedList = uploadedDocumentsList!.map((document) => document.toJson()).toList();
    uploadedDocuments = uploadedList;
  }

  void addUpdateDocumentService() {
    if(validateAll() == true){
      callAddEditService();
    }else{
      CommonUtils.getIntance().toastMessage(AppText.document_title_attachment_cannot_be_blank);
    }
  }

  Future<void> callAddEditService()  async {

    getSavedData();
    List<String> titleArray = [];
    List<String> idsArray = [];
    List<MultipartFile?> files = [];

    for(var value in uploadedDocumentsList!){
      titleArray.add(value.title);
      idsArray.add(value.id.toString());
      if(value.image != null) {
        files.add(await MultipartFile.fromFile(value.image!.path, filename: value.image!.name));
      }else{
        files.add(null);
      }
    }

    Map<String, dynamic> toJson()  {
      final Map<String, dynamic> data = <String, dynamic>{};
      if(idsArray.isNotEmpty){
        data['ids'] = idsArray.join(",");
      }
      if(titleArray.isNotEmpty){
        data['title'] = titleArray.join(",");
      }
      if(deletedDocumentsList.isNotEmpty){
        data['delete_documents'] = deletedDocumentsList.join(',');
      }
      if(files.isNotEmpty) {
        data['files[]'] = files;
      }
      return data;
    }

    if(titleArray.isEmpty && idsArray.isEmpty && files.isEmpty) {
        Get.back();
      }else{
      var apiService = _repository.sendMultipartApiRequest(toJson(),add_edit_document,false);
      callDataService(
          apiService,
          onSuccess: successResponseAddEdit,
          onError: handleOnError,
          isShowLoading: true
      );
    }
  }

  Future<void> successResponseAddEdit(dynamic baseResponse) async {

    BaseModel response = BaseModel.fromJson(baseResponse.data);

    Fluttertoast.showToast(msg: response.response_msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Clr.primaryColor,
        textColor: Clr.white,
        fontSize: 16.0
    );

    if(response.success == true) {
      Get.back(result: true);
    }
  }

  // error response manage here
  void handleOnError(dynamic e) {
    if(e is ApiException){
      Fluttertoast.showToast(msg: e.response_msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Clr.primaryColor,
          textColor: Clr.white,
          fontSize: 16.0
      );
    }

  }

  bool validateAll() {
    bool isValid = true;
    for (final controller in textfieldControllers) {
      if (controller.text.isEmpty) {
        isValid = false;
      }
    }

    for(int i=0; i<documentList!.length; i++){
      if(documentList![i].fileUrl!.isEmpty){
        if(images[i] == null){
          isValid = false;
          break;
        }
      }
    }
    return isValid;
  }

  void addMoreDocuments() {
    Document document = Document();
    document.id = 0;
    document.title = "";
    document.fileName = "";
    document.fileUrl = "";
    document.teacherId = -1;
    addMultipleFields(document,true);
  }
}
