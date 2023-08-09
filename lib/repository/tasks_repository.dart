import 'package:alfred_app/domain/data/task.dart';
import 'package:alfred_app/domain/local/tasks_store.dart';
import 'package:alfred_app/domain/remote/tasks_api.dart';

const tasksBoxName = 'tasks';

class TasksRepository {
  final TasksAPI _tasksAPI;
  final TasksStore _tasksStore;

  TasksRepository(this._tasksAPI, this._tasksStore);

  Stream<List<Task>> watchTasks() {
    return _tasksStore.watchTasks();
  }

  Future<List<Task>> fetchTasks() async {
    final tasks = await _tasksAPI.fetchTasks();
    final updatedTasks = tasks
        .map(
          (element) => element.copyWith(
            completeBy: element.completeBy.toLocal(),
          ),
        )
        .toList();
    await _tasksStore.setTasks(updatedTasks);
    return updatedTasks
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

    final createdTaskToLocal = createdTask.copyWith(
      completeBy: createdTask.completeBy.toLocal(),
    );
    await _tasksStore.addTask(createdTaskToLocal);
    return createdTaskToLocal;
  }

  Future<Task> updateTask(Task task, bool isCompleted) async {
    await _tasksStore.updateTask(
      task,
      isCompleted,
    );
    final updatedTask = await _tasksAPI.update(task, isCompleted);
    return updatedTask.copyWith(
      completeBy: updatedTask.completeBy.toLocal(),
    );
  }

  Future<void> deleteTask(Task task) async {
    await _tasksStore.deleteTask(task);
    await _tasksAPI.delete(task);
  }
}
