import 'package:alfred_app/common/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddEventDialog extends AppDialog {
  AddEventDialog({
    super.key,
  }) : super(
          child: const _AddEventDialogContent(),
        );
}

class _AddEventDialogContent extends HookConsumerWidget {
  const _AddEventDialogContent({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
