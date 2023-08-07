import 'package:alfred_app/flow/journal/providers/journal_provider.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:alfred_app/hooks/translation_hook.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class JournalScreen extends HookConsumerWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();

    final journalEntries = ref.watch(journalNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          t.journal,
          style: const TextStyle(
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
      body: journalEntries.when(
        data: (entries) {
          return Column();
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
