import 'package:get/get.dart';

import '../../data/remote/project_remote_data_source.dart';
import '../../data/remote/project_remote_data_source_impl.dart';
import '../../data/repository/project_repository.dart';
import '../../data/repository/project_repository_impl.dart';
import 'BottomNavController.dart';


class BottomNavBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController(),);
    Get.lazyPut<ProjectRepository>(() => ProjectRepositoryImpl(), tag: (ProjectRepository).toString(),);
    Get.lazyPut<ProjectRemoteDataSource>(() => ProjectRemoteDataSourceImpl(), tag: (ProjectRemoteDataSource).toString(),);
  }

}
