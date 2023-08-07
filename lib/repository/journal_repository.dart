import 'package:alfred_app/domain/data/journal_entry.dart';
import 'package:alfred_app/domain/remote/journal_api.dart';

class JournalRepository {
  final JournalAPI _journalAPI;

  JournalRepository(this._journalAPI);

  Future<List<JournalEntry>> fetchJournalEntries() async {
    return await _journalAPI.fetchJournalEntries();
  }
}
