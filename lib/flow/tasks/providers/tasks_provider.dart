import 'dart:developer';

import 'package:alfred_app/domain/data/task.dart';
import 'package:alfred_app/providers/repository_providers.dart';
import 'package:alfred_app/repository/tasks_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tasksNotifier =
    StateNotifierProvider<TasksNotifier, AsyncValue<List<Task>>>(
  (ref) => TasksNotifier(
    ref.read(tasksRepositoryProvider),
  ),
);

class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TasksRepository _tasksRepository;

  TasksNotifier(
    this._tasksRepository,
  ) : super(const AsyncLoading()) {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final tasks = await _tasksRepository.fetchTasks();
    log(tasks.toString());
    state = AsyncData(tasks);
  }
}
