import 'package:alfred_app/hooks/translation_hook.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class AppCalendar extends HookConsumerWidget {
  final DateTime? focusedDate;
  const AppCalendar({
    Key? key,
    this.focusedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();

    return TableCalendar(
      focusedDay: focusedDate ?? DateTime.now(),
      firstDay: DateTime(1970, 1, 1),
      lastDay: DateTime(2100, 12, 31),
    );
  }
}
