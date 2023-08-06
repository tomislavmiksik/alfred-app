import 'package:alfred_app/domain/data/task.dart';
import 'package:alfred_app/domain/remote/tasks_api.dart';
import 'package:hive/hive.dart';

const tasksBoxName = 'tasks';

class TasksRepository {
  final TasksAPI _tasksAPI;

  TasksRepository(this._tasksAPI);

  Future<List<Task>> fetchTasks() async {
    final tasks = await _tasksAPI.fetchTasks();
    final box = await Hive.openBox(tasksBoxName);
    await box.clear();
    await box.addAll(tasks);
    return tasks
        .where((element) => element.completeBy.isAfter(DateTime.now()))
        .toList();
  }

  Future<Task> createTask({
    required String title,
    required DateTime completeBy,
  }) async {
    final createdTask = await _tasksAPI.create(
      title: title,
      completeBy: completeBy,
    );
    final box = await Hive.openBox(tasksBoxName);
    await box.add(createdTask);

    return createdTask;
  }

  Future<Task> updateTask(Task task, bool isCompleted) async {
    final updatedTask = await _tasksAPI.update(task, isCompleted);
    final box = await Hive.openBox(tasksBoxName);
    await box.put(updatedTask.id, updatedTask);
    return updatedTask;
  }

  Future<void> deleteTask(Task task) async {
    final box = await Hive.openBox(tasksBoxName);
    await box.delete(task.id);
    await _tasksAPI.delete(task);
  }
}
