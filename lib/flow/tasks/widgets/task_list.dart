import 'package:alfred_app/common/alert_dialog.dart';
import 'package:alfred_app/domain/data/task.dart';
import 'package:alfred_app/extensions/date_time_extensions.dart';
import 'package:alfred_app/flow/tasks/providers/tasks_provider.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:alfred_app/hooks/translation_hook.dart';
import 'package:flutter/material.dart' hide AlertDialog;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskList extends HookConsumerWidget {
  final List<Task> tasks;
  const TaskList({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    return Column(
      children: tasks
          .map(
            (task) => Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: task.completed
                      ? AppColors.colorPrimary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () {
                    ref
                        .read(tasksNotifier.notifier)
                        .updateTask(task, !task.completed);
                  },
                  onLongPress: () {
                    AlertDialog.show(
                      context,
                      title: t.deleteTaskConfirmation,
                      description: '',
                      cancelText: t.cancel,
                      okText: t.delete,
                      onOkPressed: () {
                        ref.read(tasksNotifier.notifier).deleteTask(task);
                      },
                    );
                  },
                  title: Text(
                    task.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      text: t.completeBy,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: task.completeBy.asMmDdYyHHMm,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Checkbox(
                    value: task.completed,
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                    checkColor: Colors.white,
                    fillColor:
                        MaterialStateProperty.all(AppColors.colorPrimary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (value) {},
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
