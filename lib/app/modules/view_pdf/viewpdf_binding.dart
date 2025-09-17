import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/forgot_password/forgotpassword_controller.dart';
import 'package:vteach_teacher/app/modules/view_pdf/viewpdf_controller.dart';

import '../../data/remote/project_remote_data_source.dart';
import '../../data/remote/project_remote_data_source_impl.dart';
import '../../data/repository/project_repository.dart';
import '../../data/repository/project_repository_impl.dart';


class ViewPdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewPdfController>(() => ViewPdfController(),);
    Get.lazyPut<ProjectRepository>(() => ProjectRepositoryImpl(), tag: (ProjectRepository).toString(),);
    Get.lazyPut<ProjectRemoteDataSource>(() => ProjectRemoteDataSourceImpl(), tag: (ProjectRemoteDataSource).toString(),);
  }
}
