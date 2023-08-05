import 'package:alfred_app/domain/data/task.dart';
import 'package:alfred_app/domain/remote/tasks_api.dart';
import 'package:hive/hive.dart';

class TasksRepository {
  final TasksAPI _tasksAPI;

  TasksRepository(this._tasksAPI);

  Future<List<Task>> fetchTasks() async {
    final tasks = await _tasksAPI.fetchTasks();
    await Hive.openBox('tasks');
    return tasks;
  }
}
