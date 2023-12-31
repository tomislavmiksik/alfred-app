import 'package:alfred_app/domain/data/event.dart';
import 'package:alfred_app/domain/remote/events_api.dart';

class EventsRepository {
  final EventsAPI _eventsAPI;

  EventsRepository(this._eventsAPI);

  Future<List<Event>> fetchEvents() async {
    final events = await _eventsAPI.fetchEvents();

    return events
        .map((e) => e.copyWith(eventDate: e.eventDate.toLocal()))
        .toList();
  }

  Future<Event> create({
    required String title,
    String? description,
    required DateTime date,
  }) async {
    final event = await _eventsAPI.create(
      title: title,
      description: description,
      date: date,
    );

    return event.copyWith(eventDate: event.eventDate.toLocal());
  }

  Future<Event> update(Event event) async {
    final updatedEvent = await _eventsAPI.update(event);

    return updatedEvent.copyWith(eventDate: updatedEvent.eventDate.toLocal());
  }

  Future<void> delete(Event event) async {
    return await _eventsAPI.delete(event);
  }
}
