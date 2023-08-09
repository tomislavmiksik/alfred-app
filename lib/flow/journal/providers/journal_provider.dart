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
    log("JournalNotifier: fetchJournalEntries completed: ${entries.map((e) => e.createdAt)}");
  }

  Future<void> createJournalEntry({
    required String title,
    required String description,
    required DateTime date,
  }) async {
    log('JournalNotifier: createJournalEntry started ${state.valueOrNull?.length}');
    final entry = await _journalRepository.create(
      title: title,
      description: description,
      date: date,
    );
    state = AsyncData([...?state.valueOrNull, entry]);
    log("JournalNotifier: createJournalEntry completed: $entry ${state.valueOrNull?.length}");
  }

  Future<void> updateJournalEntry({
    required JournalEntry journalEntry,
    required String title,
    required String description,
    required DateTime date,
  }) async {
    final entry = await _journalRepository.update(
      journalEntry: journalEntry,
      title: title,
      description: description,
      date: date,
    );

    //todo: fixati jednog dana
    await fetchJournalEntries();
    state = AsyncData([...?state.valueOrNull, entry]);
  }

  Future<void> deleteJournalEntry({
    required JournalEntry journalEntry,
  }) async {
    state = const AsyncLoading();
    try {
      await _journalRepository.deleteJournalEntry(
        journalEntry: journalEntry,
      );
    } catch (e) {
      // TODO
    }
    await fetchJournalEntries();
    state = AsyncData([...?state.valueOrNull]);
  }
}
