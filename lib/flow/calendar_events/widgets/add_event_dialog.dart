import 'package:alfred_app/common/app_dialog.dart';
import 'package:alfred_app/flow/calendar_events/providers/events_provider.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:alfred_app/hooks/form_hook.dart';
import 'package:alfred_app/hooks/translation_hook.dart';
import 'package:alfred_app/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddEventDialog extends AppDialog {
  AddEventDialog({
    super.key,
  }) : super(child: const _AddEventDialogContent());
}

class _AddEventDialogContent extends HookConsumerWidget {
  const _AddEventDialogContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();

    final form = useForm({
      'title': FormControl<String>(validators: [Validators.required]),
      'date': FormControl<DateTime>(validators: [Validators.required]),
      'time': FormControl<TimeOfDay>(validators: [Validators.required]),
    });

    final handleSubmit = useCallback(() async {
      final title = form.control('title').value as String;
      final date = form.control('date').value as DateTime;
      final time = form.control('time').value as TimeOfDay;
      ref.read(eventsNotifierProvider.notifier).create(
            title: title,
            date: date.copyWith(
              hour: time.hour,
              minute: time.minute,
            ),
          );
    }, [form, 0]);

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
                t.addEvent,
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
                Icons.edit_calendar_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.colorBackgroundPopUp,
        body: ReactiveForm(
          formGroup: form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    t.createEvent,
                    style: const TextStyle(
                      fontSize: 26,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ReactiveTextField(
                    formControlName: 'title',
                    decoration: InputDecoration(
                      labelText: t.eventTitle,
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.colorPrimary,
                        ),
                      ),
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
                            yearOverlayColor: MaterialStatePropertyAll<Color>(
                              Colors.white,
                            ),
                            backgroundColor: AppColors.colorBackgroundPopUp,
                            dayStyle: TextStyle(
                              color: Colors.white,
                            ),
                            weekdayStyle: TextStyle(
                              color: Colors.white,
                            ),
                            dayForegroundColor: MaterialStatePropertyAll<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                    child: ReactiveDatePicker(
                      formControlName: 'date',
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
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
                            labelText: t.date,
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
                        timePickerTheme: const TimePickerThemeData(
                          backgroundColor: AppColors.colorBackgroundPopUp,
                          dialTextColor: Colors.white,
                          hourMinuteTextColor: Colors.white,
                          dayPeriodTextColor: Colors.white,
                          entryModeIconColor: AppColors.colorPrimary,
                        ),
                      ),
                  child: ReactiveTimePicker(
                    formControlName: 'time',
                    builder: (context, picker, child) {
                      return ReactiveTextField(
                        formControlName: 'time',
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
                          labelText: t.time,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () => picker.showPicker(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
