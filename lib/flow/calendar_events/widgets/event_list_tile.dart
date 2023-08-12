import 'package:alfred_app/domain/data/event.dart';
import 'package:alfred_app/extensions/date_time_extensions.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:flutter/material.dart';

class EventListItem extends StatelessWidget {
  final Event event;
  final Function(Event) onEventTap;

  const EventListItem({
    Key? key,
    required this.event,
    required this.onEventTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onEventTap(event),
      title: Text(event.title),
      trailing: Text(event.eventDate.asMmDdYyHHMm),
      shape: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.colorPrimary,
          width: 1,
        ),
      ),
    );
  }
}
