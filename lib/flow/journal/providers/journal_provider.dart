import 'dart:developer';

import 'package:alfred_app/domain/data/journal_entry.dart';
import 'package:alfred_app/providers/repository_providers.dart';
import 'package:alfred_app/repository/journal_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final journalNotifierProvider =
    StateNotifierProvider<JournalNotifier, AsyncValue<List<JournalEntry>>>(
  (ref) => JournalNotifier(
    ref.read(journalRepositoryProvider),
  ),
);

class JournalNotifier extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  final JournalRepository _journalRepository;

  JournalNotifier(this._journalRepository) : super(const AsyncValue.loading()) {
    fetchJournalEntries();
  }

  Future<void> fetchJournalEntries() async {
    final entries = await _journalRepository.fetchJournalEntries();
    state = AsyncData(entries);
    log("JournalNotifier: fetchJournalEntries completed: $entries");
  }
}
