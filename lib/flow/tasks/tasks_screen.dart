import 'package:alfred_app/flow/tasks/providers/tasks_provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class TasksScreen extends HookConsumerWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksNotifier);
    return const Center(
      child: Text('Tasks'),
    );
  }
}
