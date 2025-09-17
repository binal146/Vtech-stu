import 'package:get/get.dart';
import '../../data/remote/project_remote_data_source.dart';
import '../../data/remote/project_remote_data_source_impl.dart';
import '../../data/repository/project_repository.dart';
import '../../data/repository/project_repository_impl.dart';
import 'contact_us_controller.dart';

class ContactUsBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<ContactUsController>(
      () => ContactUsController(),
    );

    Get.lazyPut<ProjectRepository>(
          () => ProjectRepositoryImpl(),
      tag: (ProjectRepository).toString(),
    );

    Get.lazyPut<ProjectRemoteDataSource>(
          () => ProjectRemoteDataSourceImpl(),
      tag: (ProjectRemoteDataSource).toString(),
    );
  }
}
