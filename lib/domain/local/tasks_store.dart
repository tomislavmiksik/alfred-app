import 'package:alfred_app/domain/data/task.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxKey = 'tasks';
const _tasksKey = 'tasks-list';

class TasksStore {
  Future<List<Task>> getTasks() async {
    final box = await Hive.openBox<List<Task>>(_boxKey);
    return box.get(_tasksKey) ?? [];
  }

  Future<void> setTasks(List<Task> tasks) async {
    final box = await Hive.openBox<List<Task>>(_boxKey);
    await box.put(_tasksKey, tasks);
  }

  Future<void> addTask(Task task) async {
    final box = await Hive.openBox<List<Task>>(_boxKey);
    final tasks = box.get(_tasksKey) ?? [];
    tasks.add(task);
    await box.put(_tasksKey, tasks);
  }

  Future<void> updateTask(Task task, bool isCompleted) async {
    final box = await Hive.openBox<List<Task>>(_boxKey);
    final tasks = box.get(_tasksKey) ?? [];
    final updatedTasks = tasks.map((e) {
      if (e.id == task.id) {
        return task.copyWith(completed: isCompleted);
      }
      return e;
    }).toList();
    await box.put(_tasksKey, updatedTasks);
  }

  Future<void> deleteTask(Task task) async {
    final box = await Hive.openBox<List<Task>>(_boxKey);
    final tasks = box.get(_tasksKey) ?? [];
    tasks.removeWhere((element) => element.id == task.id);
    await box.put(_tasksKey, tasks);
  }

  Stream<List<Task>> watchTasks() async* {
    final box = await Hive.openBox<List<Task>>(_boxKey);
    yield* box.watch(key: _tasksKey).map(
      (event) {
        return event.value ?? [];
      },
    );
  }
}
