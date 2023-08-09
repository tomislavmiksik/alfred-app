import 'package:alfred_app/domain/data/event.dart';
import 'package:alfred_app/providers/repository_providers.dart';
import 'package:alfred_app/repository/events_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final eventsNotifierProvider =
    StateNotifierProvider<EventsNotifier, AsyncValue<List<Event>>>(
  (ref) => EventsNotifier(
    ref.read(eventsRepositoryProvider),
  ),
);

class EventsNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final EventsRepository _eventsRepository;

  EventsNotifier(this._eventsRepository) : super(const AsyncValue.loading()) {
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    state = const AsyncValue.loading();

    try {
      final events = await _eventsRepository.fetchEvents();
      state = AsyncValue.data(events);
    } catch (e) {}
  }

  Future<void> create({
    required String title,
    required String description,
    required DateTime date,
  }) async {
    final event = await _eventsRepository.create(
      title: title,
      description: description,
      date: date,
    );

    state.whenData((events) {
      state = AsyncValue.data([...events, event]);
    });
  }

  Future<void> update(Event event) async {
    final updatedEvent = await _eventsRepository.update(event);

    state.whenData((events) {
      state = AsyncValue.data(events
          .map((e) => e.id == updatedEvent.id ? updatedEvent : e)
          .toList());
    });
  }

  Future<void> delete(Event event) async {
    await _eventsRepository.delete(event);

    state.whenData((events) {
      state = AsyncValue.data(events.where((e) => e.id != event.id).toList());
    });
  }
}
