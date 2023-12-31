import 'package:alfred_app/domain/data/task.dart';
import 'package:alfred_app/providers/repository_providers.dart';
import 'package:alfred_app/repository/tasks_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

final tasksNotifier =
    StateNotifierProvider<TasksNotifier, AsyncValue<List<Task>>>(
  (ref) => TasksNotifier(
    ref.read(tasksRepositoryProvider),
  ),
);

class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TasksRepository _tasksRepository;
  late final CompositeSubscription _compositeSubscription =
      CompositeSubscription();

  TasksNotifier(
    this._tasksRepository,
  ) : super(const AsyncLoading()) {
    _compositeSubscription.add(
      _tasksRepository.watchTasks().doOnListen(fetchTasks).listen(
        (tasks) {
          state = AsyncData(
            tasks
                .where((element) => element.completeBy.isAfter(DateTime.now()))
                .toList(),
          );
        },
      ),
    );
  }

  Future<void> fetchTasks() async {
    final tasks = await _tasksRepository.fetchTasks();
    state = AsyncData(tasks);
  }

  Future<void> createTask({
    required String title,
    required DateTime completeBy,
  }) async {
    await _tasksRepository.createTask(
      title: title,
      completeBy: completeBy,
    );
  }

  Future<void> updateTask(Task task, bool isCompleted) async {
    final updatedTask = await _tasksRepository.updateTask(task, isCompleted);
    state = AsyncData(
      state.valueOrNull!
          .map((t) => t.id == updatedTask.id ? updatedTask : t)
          .toList(),
    );
  }

  Future<void> deleteTask(Task task) async {
    try {
      await _tasksRepository.deleteTask(task);
    } on Exception catch (e) {
      // TODO
    }
    state = AsyncData(
      state.valueOrNull!.where((t) => t.id != task.id).toList(),
    );
  }
}
