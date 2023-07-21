import 'package:ProFlow/navigation/student/my%20project/data/providers/task/provider.dart';
import '../../models/task.dart';

class TaskRepository {
  TaskProvider taskProvider;
  TaskRepository({required this.taskProvider});

  Future<List<Task>> readTasks() async {
    return taskProvider.readTasks();
  }

  void writeTasks(List<Task> tasks) => taskProvider.writeTasks(tasks);
}
