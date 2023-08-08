import 'package:alfred_app/domain/data/journal_entry.dart';
import 'package:alfred_app/domain/remote/journal_api.dart';

class JournalRepository {
  final JournalAPI _journalAPI;

  JournalRepository(this._journalAPI);

  Future<List<JournalEntry>> fetchJournalEntries() async {
    final entries = await _journalAPI.fetchJournalEntries();

    return entries.map((e) => e.copyWith(date: e.date.toLocal())).toList();
  }

  Future<JournalEntry> create({
    required String title,
    required String description,
    required DateTime date,
  }) async {
    final entry = await _journalAPI.create(
      title: title,
      description: description,
      date: date,
    );

    return entry.copyWith(date: entry.date.toLocal());
  }

  Future<JournalEntry> update({
    required JournalEntry journalEntry,
    required String title,
    required String description,
    required DateTime date,
  }) async {
    return await _journalAPI.update(
      journalEntry: journalEntry,
      title: title,
      description: description,
      date: date.toLocal(),
    );
  }

  Future<void> deleteJournalEntry({
    required JournalEntry journalEntry,
  }) async {
    return await _journalAPI.delete(journalEntry);
  }
}
