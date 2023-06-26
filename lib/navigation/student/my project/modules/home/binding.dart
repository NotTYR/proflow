import 'package:ProFlow/navigation/student/my%20project/data/providers/task/provider.dart';
import 'package:ProFlow/navigation/student/my%20project/data/services/storage/repository.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        taskRepository: TaskRepository(
          taskProvider: TaskProvider(),
        ),
      ),
    );
  }
}
