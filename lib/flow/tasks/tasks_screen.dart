import 'package:alfred_app/flow/tasks/providers/tasks_provider.dart';
import 'package:alfred_app/flow/tasks/widgets/task_list.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class TasksScreen extends HookConsumerWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksNotifier);
    final completedTasks = useState(0);
    final totalTasks = useState(0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Tasks',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.normal,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(
            color: AppColors.colorPrimary,
            width: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(tasksNotifier.notifier).fetchTasks();
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: MultiSliver(
                  children: [
                    tasks.when(
                      data: (tasks) {
                        completedTasks.value =
                            tasks.where((element) => element.completed).length;
                        totalTasks.value = tasks.length;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                '${completedTasks.value} / ${totalTasks.value} tasks completed',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: totalTasks.value != 0
                                    ? LinearProgressIndicator(
                                        value: completedTasks.value /
                                            totalTasks.value,
                                        backgroundColor: Colors.grey[300],
                                        minHeight: 8,
                                      )
                                    : const SizedBox(),
                              ),
                            ),
                            TaskList(tasks: tasks),
                          ],
                        );
                      },
                      error: (_, __) => const Center(
                        child: Text(
                          'Error',
                          style: TextStyle(fontSize: 26),
                        ),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
