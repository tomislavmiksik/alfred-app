import 'package:alfred_app/domain/data/journal_entry.dart';
import 'package:alfred_app/domain/remote/responses/remote_list.dart';
import 'package:alfred_app/extensions/date_time_extensions.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'journal_api.g.dart';

@RestApi()
abstract class _JournalAPI {
  factory _JournalAPI(Dio dio) = __JournalAPI;

  @GET('/journal-entries')
  Future<RemoteList<JournalEntry>> getJournalEntries();

  @POST('/journal-entries')
  Future<JournalEntry> createJournalEntry(
      @Body() Map<String, dynamic> journalEntry);

  @PUT('/journal-entries/{id}')
  Future<JournalEntry> updateJournalEntry(
    @Path('id') int id,
    @Body() Map<String, dynamic> journalEntry,
  );

  @DELETE('/journal-entries/{id}')
  Future<void> deleteJournalEntry(@Path('id') int id);
}

class JournalAPI extends __JournalAPI {
  JournalAPI(Dio dio) : super(dio);

  Future<List<JournalEntry>> fetchJournalEntries() async {
    final remoteList = await getJournalEntries();
    return remoteList.data as List<JournalEntry>;
  }

  Future<JournalEntry> create({
    required String title,
    required String description,
    required DateTime date,
  }) async {
    final body = {
      "data": {
        "title": title,
        "description": description,
        "date": date.toIso8601UtcString(),
      }
    };
    return await createJournalEntry(body);
  }

  Future<JournalEntry> update({
    required JournalEntry journalEntry,
    required String title,
    required String description,
    required DateTime date,
  }) async {
    final body = {
      "data": {
        "title": title,
        "description": description,
        "date": journalEntry.date.toIso8601String(),
      }
    };
    return await updateJournalEntry(journalEntry.id, body);
  }

  Future<void> delete(JournalEntry journalEntry) async {
    await deleteJournalEntry(journalEntry.id);
  }
}
