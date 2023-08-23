import 'package:alfred_app/domain/data/event.dart';
import 'package:alfred_app/extensions/date_time_extensions.dart';
import 'package:alfred_app/flow/calendar_events/providers/events_provider.dart';
import 'package:alfred_app/flow/calendar_events/widgets/calendar_event_list_dialog.dart';
import 'package:alfred_app/flow/calendar_events/widgets/edit_event_dialog.dart';
import 'package:alfred_app/flow/calendar_events/widgets/event_list_tile.dart';
import 'package:alfred_app/flow/calendar_events/widgets/events_calendar.dart';
import 'package:alfred_app/hooks/translation_hook.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class CalendarEventsScreen extends HookConsumerWidget {
  const CalendarEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();

    final events = ref.watch(eventsNotifierProvider);

    final handleEventTapped = useCallback(
      (Event event) {
        EditEventDialog(
          event: event,
        ).show(context);
      },
      [events],
    );

    final handleShowEvents = useCallback(
      (DateTime date) {
        final eventsForDate = events.valueOrNull
                ?.where((event) => event.eventDate.isInTheSameDay(date))
                .sortedBy((e) => e.eventDate)
                .toList() ??
            [];

        CalendarEventListDialog(
          context: context,
          date: date,
          onEventTap: handleEventTapped,
        ).show(context);
      },
      [events, handleEventTapped],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          t.events,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: events.when(
          data: (events) {
            final upcomingEvents = events
                .where((event) => event.eventDate.isAfter(DateTime.now()))
                .sortedBy((e) => e.eventDate)
                .take(5)
                .toList();
            return CustomScrollView(
              slivers: [
                MultiSliver(
                  children: [
                    EventsCalendar(
                      events: events,
                      handleShowEvents: handleShowEvents,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        t.upcomingEvents,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (final event in upcomingEvents)
                      EventListItem(
                        event: event,
                        onEventTap: handleEventTapped,
                      ),
                    const SizedBox(height: 64),
                  ],
                ),
              ],
            );
          },
          error: (_, __) => const SizedBox.shrink(),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
