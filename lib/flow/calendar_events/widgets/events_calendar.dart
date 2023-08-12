import 'package:alfred_app/domain/data/event.dart';
import 'package:alfred_app/extensions/date_time_extensions.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsCalendar extends HookConsumerWidget {
  final List<Event> events;
  final Function(DateTime) handleShowEvents;
  const EventsCalendar({
    Key? key,
    required this.events,
    required this.handleShowEvents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TableCalendar(
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.colorPrimary,
              width: 1,
            ),
          ),
        ),
        headerMargin: EdgeInsets.all(16),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.white,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      daysOfWeekHeight: 40,
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        weekendStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          return Center(
            child: Text(
              DateFormat('E').format(day),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        defaultBuilder: (context, date, _) {
          final eventExistsForDate = events.firstWhereOrNull(
                  (element) => element.eventDate.isInTheSameDay(date)) !=
              null;
          return InkWell(
            onTap: () => handleShowEvents(date),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (eventExistsForDate)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.colorPrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    Padding(
                      padding: !eventExistsForDate
                          ? const EdgeInsets.only(top: 8)
                          : const EdgeInsets.all(0),
                      child: Text(
                        date.day.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        todayBuilder: (context, date, _) {
          final eventExistsForDate = events.firstWhereOrNull(
                  (element) => element.eventDate.isInTheSameDay(date)) !=
              null;
          return InkWell(
            onTap: () => handleShowEvents(date),
            child: Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.colorPrimary,
                    width: 2,
                  ),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (eventExistsForDate)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.colorPrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    Padding(
                      padding: !eventExistsForDate
                          ? const EdgeInsets.only(top: 8)
                          : const EdgeInsets.all(0),
                      child: Text(
                        date.day.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      focusedDay: DateTime.now(),
      firstDay: DateTime(1970, 1, 1),
      lastDay: DateTime(2050, 12, 31),
    );
  }
}
