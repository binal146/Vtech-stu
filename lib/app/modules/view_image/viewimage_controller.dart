import 'dart:async';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import '../../data/repository/project_repository.dart';
import '/app/core/base/base_controller.dart';

class ViewImageController extends BaseController {

  final ProjectRepository _repository = Get.find(tag: (ProjectRepository).toString());

  // late PDFDocument document;

   String pdfTitle = "";
   String fileUrl = "";
  @override
  Future<void> onInit() async {
    super.onInit();
   // document = Get.arguments;
   // pdfTitle = Get.parameters['pdf_title']!;
    fileUrl = Get.parameters['file_url']!;
  }

}
