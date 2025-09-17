import 'package:get/get.dart';
import 'package:vteach_teacher/app/modules/signup_2/signup2_controller.dart';
import '../../data/remote/project_remote_data_source.dart';
import '../../data/remote/project_remote_data_source_impl.dart';
import '../../data/repository/project_repository.dart';
import '../../data/repository/project_repository_impl.dart';


class SignUp2Binding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<SignUp2Controller>(
      () => SignUp2Controller(),
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
