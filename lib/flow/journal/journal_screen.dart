import 'package:alfred_app/domain/data/journal_entry.dart';
import 'package:alfred_app/extensions/date_time_extensions.dart';
import 'package:alfred_app/flow/journal/providers/journal_provider.dart';
import 'package:alfred_app/flow/journal/widgets/add_journal_entry_dialog.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:alfred_app/hooks/translation_hook.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class JournalScreen extends HookConsumerWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final journalEntries = ref.watch(journalNotifierProvider);
    final selectedDay = useState(DateTime.now());

    final handleNavigateDays = useCallback((bool isNext) {
      selectedDay.value = selectedDay.value.add(
        Duration(days: isNext ? 1 : -1),
      );
    }, [selectedDay.value]);

    final handleDeleteEntry = useCallback(
      (JournalEntry entry) {
        ref.read(journalNotifierProvider.notifier).deleteJournalEntry(
              journalEntry: entry,
            );
      },
      [],
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            t.journal,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async => await ref
              .read(journalNotifierProvider.notifier)
              .fetchJournalEntries(),
          child: journalEntries.when(
            error: (_, __) => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            data: (entries) {
              final selectedDayEntry = entries.firstWhereOrNull(
                (e) => e.date.isInTheSameDay(selectedDay.value),
              );
              return CustomScrollView(
                slivers: [
                  MultiSliver(
                    children: [
                      SliverPinnedHeader(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColors.colorPrimary,
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => handleNavigateDays(false),
                                    splashColor: Colors.transparent,
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      selectedDay.value.asMmDdYy,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: selectedDay.value
                                            .isInTheSameDay(DateTime.now())
                                        ? null
                                        : () => handleNavigateDays(true),
                                    splashColor: Colors.transparent,
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.white,
                              height: 1,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColors.colorPrimaryBackground,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () => AddJournalEntryDialog(
                                      journalEntry: selectedDayEntry,
                                      journalEntries: entries,
                                    ).show(context),
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => handleDeleteEntry(
                                      selectedDayEntry!,
                                    ),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: AppColors.colorSemanticRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      selectedDayEntry != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 48,
                              ),
                              child: MarkdownWidget(
                                shrinkWrap: true,
                                markdownGeneratorConfig:
                                    MarkdownGeneratorConfig(),
                                config: MarkdownConfig(
                                  configs: [
                                    PreConfig(
                                      decoration: BoxDecoration(
                                        color: AppColors.colorBackgroundPopUp,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const CodeConfig(
                                      style: TextStyle(
                                        fontSize: 14,
                                        backgroundColor: Colors.grey,
                                        color: Colors.black,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                                data: selectedDayEntry.description,
                              ),
                            )
                          : SliverFillRemaining(
                              child: Center(
                                child: Text(t.noEntryForThisDay),
                              ),
                            ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
