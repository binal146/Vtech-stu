import 'package:get/get.dart';
import 'package:vteach_teacher/app/data/remote/project_remote_data_source_impl.dart';
import '../data/remote/project_remote_data_source.dart';


class RemoteSourceBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectRemoteDataSource>(
      () => ProjectRemoteDataSourceImpl(),
      tag: (ProjectRemoteDataSource).toString(),
    );
  }
}
