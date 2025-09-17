import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/repository/project_repository.dart';
import '/app/core/base/base_controller.dart';

class TeacherDetailController extends BaseController {

  TextEditingController searchContoller = TextEditingController();

  final ProjectRepository _repository =
  Get.find(tag: (ProjectRepository).toString());

  @override
  Future<void> onInit() async {
    super.onInit();

  }

}


