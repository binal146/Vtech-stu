import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/appoint_success/appoint_success_controller.dart';
import '../../data/remote/project_remote_data_source.dart';
import '../../data/remote/project_remote_data_source_impl.dart';
import '../../data/repository/project_repository.dart';
import '../../data/repository/project_repository_impl.dart';


class AppointSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppointSuccessController>(() => AppointSuccessController(),);
    Get.lazyPut<ProjectRepository>(() => ProjectRepositoryImpl(), tag: (ProjectRepository).toString(),);
    Get.lazyPut<ProjectRemoteDataSource>(() => ProjectRemoteDataSourceImpl(), tag: (ProjectRemoteDataSource).toString(),);
  }
}
