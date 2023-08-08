import 'dart:developer';

import 'package:alfred_app/common/app_dialog.dart';
import 'package:alfred_app/domain/data/journal_entry.dart';
import 'package:alfred_app/extensions/date_time_extensions.dart';
import 'package:alfred_app/flow/journal/providers/journal_provider.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:alfred_app/hooks/form_hook.dart';
import 'package:alfred_app/hooks/translation_hook.dart';
import 'package:alfred_app/theme/default.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AddJournalEntryDialog extends AppDialog {
  final JournalEntry? journalEntry;
  final List<JournalEntry> journalEntries;
  AddJournalEntryDialog({
    super.key,
    this.journalEntry,
    required this.journalEntries,
  }) : super(
          child: _AddJournalEntryDialogContent(
            journalEntry: journalEntry,
            journalEntries: journalEntries,
          ),
        );
}

class _AddJournalEntryDialogContent extends HookConsumerWidget {
  final JournalEntry? journalEntry;
  final List<JournalEntry> journalEntries;
  const _AddJournalEntryDialogContent({
    Key? key,
    this.journalEntry,
    required this.journalEntries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();

    final controller = useTextEditingController(
      text: journalEntry?.description,
    );

    final form = useForm({
      'date': FormControl<DateTime>(
        value: journalEntry?.date,
        validators: [Validators.required],
      ),
      'description': FormControl<String>(
        value: journalEntry?.description,
        validators: [Validators.required],
      ),
    });

    useEffect(() {
      final date = form.control('date').value;
      log('date: $date');
      form.control('description').value = '';
      controller.text = '';
      if (date != null &&
          journalEntries.firstWhereOrNull((e) => e.date.isInTheSameDay(date)) !=
              null) {
        final entry = journalEntries
            .firstWhereOrNull((e) => e.date.isInTheSameDay(date))
            ?.description;
        form.control('description').value = entry;
        controller.text = entry ?? '';
      }
    }, [journalEntry, journalEntries, form.control('date').value, controller]);

    final handleSubmit = useCallback(() async {
      final date = form.control('date').value;
      final description = form.control('description').value;

      final isUpdate = journalEntry != null ||
          journalEntries.firstWhereOrNull((e) => e.date.isInTheSameDay(date)) !=
              null;

      if (isUpdate) {
        final entry = journalEntry ??
            journalEntries.firstWhereOrNull((e) => e.date.isInTheSameDay(date));

        ref.read(journalNotifierProvider.notifier).updateJournalEntry(
              journalEntry: entry!,
              title: date.toString(),
              date: DateTime(date.year, date.month, date.day, 1, 1, 1),
              description: description,
            );
      } else {
        ref.read(journalNotifierProvider.notifier).createJournalEntry(
              title: date.toString(),
              date: DateTime(date.year, date.month, date.day, 1, 1, 1),
              description: description,
            );
      }
    }, [form, journalEntry, journalEntries]);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.hardEdge,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton.icon(
              label: Text(
                journalEntry == null ? t.addJournalEntry : t.updateJournalEntry,
                style: const TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.colorPrimary,
              ),
              onPressed: () async {
                if (form.valid) {
                  await handleSubmit();
                  Navigator.of(context).pop();
                } else {
                  form.markAllAsTouched();
                }
              },
              icon: const Icon(
                Icons.note_add_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.colorBackgroundPopUp,
        body: SafeArea(
          child: ReactiveForm(
            formGroup: form,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomScrollView(
                slivers: [
                  MultiSliver(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          journalEntry == null
                              ? t.createANewJournalEntry
                              : t.updateJournalEntry,
                          style: const TextStyle(
                            fontSize: 26,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Theme(
                          data: DefaultAppTheme().data.copyWith(
                                datePickerTheme: const DatePickerThemeData(
                                  headerHelpStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  yearOverlayColor:
                                      MaterialStatePropertyAll<Color>(
                                    Colors.white,
                                  ),
                                  backgroundColor:
                                      AppColors.colorBackgroundPopUp,
                                  dayStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  weekdayStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  dayForegroundColor:
                                      MaterialStatePropertyAll<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                          child: ReactiveDatePicker(
                            formControlName: 'date',
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            locale: Localizations.localeOf(context),
                            builder: (context, picker, child) {
                              return ReactiveTextField(
                                formControlName: 'date',
                                readOnly: true,
                                onTap: (_) => picker.showPicker(),
                                decoration: InputDecoration(
                                  fillColor: AppColors.colorBackgroundPopUp,
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.colorPrimary,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.colorPrimary,
                                    ),
                                  ),
                                  labelText: t.dateOfTheEntry,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => picker.showPicker(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Theme(
                        data: DefaultAppTheme().data.copyWith(
                              cardColor: AppColors.colorBackgroundPopUp,
                              iconTheme: const IconThemeData(
                                color: Colors.white,
                              ),
                              colorScheme: const ColorScheme.dark(
                                primary: Colors.transparent,
                                secondary: AppColors.colorPrimary,
                              ),
                            ),
                        child: MarkdownTextInput(
                          (value) => form.control('description').value = value,
                          form.control('description').value ?? '',
                          textStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: controller,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
