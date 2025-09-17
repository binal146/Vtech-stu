import 'package:get/get.dart';

import '../data/repository/project_repository.dart';
import '../data/repository/project_repository_impl.dart';

class RepositoryBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectRepository>(
      () => ProjectRepositoryImpl(),
      tag: (ProjectRepository).toString(),
    );
  }
}
