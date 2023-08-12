import 'package:alfred_app/common/app_dialog.dart';
import 'package:alfred_app/domain/data/event.dart';
import 'package:alfred_app/extensions/date_time_extensions.dart';
import 'package:alfred_app/flow/calendar_events/providers/events_provider.dart';
import 'package:alfred_app/flow/calendar_events/widgets/event_list_tile.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

class CalendarEventListDialog extends AppDialog {
  CalendarEventListDialog({
    super.key,
    required DateTime date,
    required BuildContext context,
    required Function(Event) onEventTap,
  }) : super(
          child: _CalendarEventListDialog(
            key: key,
            date: date,
            onEventTap: onEventTap,
          ),
        );
}

class _CalendarEventListDialog extends HookConsumerWidget {
  final Function(Event) onEventTap;
  final DateTime date;

  const _CalendarEventListDialog({
    Key? key,
    required this.date,
    required this.onEventTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref
            .watch(eventsNotifierProvider)
            .valueOrNull
            ?.where((event) => event.eventDate.isInTheSameDay(date))
            .sortedBy((e) => e.eventDate)
            .toList() ??
        [];
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            date.asMmDdYy,
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            MultiSliver(
              children: [
                for (final event in events)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: EventListItem(
                      event: event,
                      onEventTap: onEventTap,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
