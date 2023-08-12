import 'package:alfred_app/domain/data/event.dart';
import 'package:alfred_app/domain/remote/responses/remote_list.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'events_api.g.dart';

@RestApi()
abstract class _EventsAPI {
  factory _EventsAPI(Dio dio) = __EventsAPI;

  @GET('/events')
  Future<RemoteList<Event>> getEvents();

  @POST('/events')
  Future<Event> createEvent(@Body() Map<String, dynamic> event);

  @PUT('/events/{id}')
  Future<Event> updateEvent(
      @Path('id') int id, @Body() Map<String, dynamic> event);

  @DELETE('/events/{id}')
  Future<void> deleteEvent(@Path('id') int id);
}

class EventsAPI extends __EventsAPI {
  EventsAPI(Dio dio) : super(dio);

  Future<List<Event>> fetchEvents() async {
    final remoteList = await getEvents();

    return remoteList.data as List<Event>;
  }

  Future<Event> create({
    required String title,
    String? description,
    required DateTime date,
  }) async {
    final body = {
      "data": {
        "title": title,
        "description": description,
        "eventDate": date.toUtc().toIso8601String(),
      }
    };
    return await createEvent(body);
  }

  Future<Event> update(Event event) async {
    final body = {
      "data": {
        "title": event.title,
        "description": event.description,
        "date": event.eventDate.toUtc().toIso8601String(),
      }
    };
    return await updateEvent(event.id, body);
  }

  Future<void> delete(Event event) async {
    await deleteEvent(event.id);
  }
}
