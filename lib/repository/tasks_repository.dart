import 'package:alfred_app/domain/data/task.dart';
import 'package:alfred_app/domain/local/tasks_store.dart';
import 'package:alfred_app/domain/remote/tasks_api.dart';

const tasksBoxName = 'tasks';

class TasksRepository {
  final TasksAPI _tasksAPI;
  final TasksStore _tasksStore;

  TasksRepository(this._tasksAPI, this._tasksStore);

  Future<List<Task>> fetchTasks() async {
    final tasks = await _tasksAPI.fetchTasks();
    await _tasksStore.setTasks(tasks);
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
    await _tasksStore.addTask(createdTask);
    return createdTask;
  }

  Future<Task> updateTask(Task task, bool isCompleted) async {
    final updatedTask = await _tasksAPI.update(task, isCompleted);
    await _tasksStore.updateTask(updatedTask, isCompleted);
    return updatedTask;
  }

  Future<void> deleteTask(Task task) async {
    await _tasksStore.deleteTask(task);
    await _tasksAPI.delete(task);
  }
}
