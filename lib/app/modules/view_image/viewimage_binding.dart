import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/view_image/viewimage_controller.dart';
import '../../data/remote/project_remote_data_source.dart';
import '../../data/remote/project_remote_data_source_impl.dart';
import '../../data/repository/project_repository.dart';
import '../../data/repository/project_repository_impl.dart';


class ViewImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewImageController>(() => ViewImageController(),);
    Get.lazyPut<ProjectRepository>(() => ProjectRepositoryImpl(), tag: (ProjectRepository).toString(),);
    Get.lazyPut<ProjectRemoteDataSource>(() => ProjectRemoteDataSourceImpl(), tag: (ProjectRemoteDataSource).toString(),);
  }
}
