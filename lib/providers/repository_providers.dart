import 'package:alfred_app/providers/di/store_providers.dart';
import 'package:alfred_app/providers/network_providers.dart';
import 'package:alfred_app/repository/journal_repository.dart';
import 'package:alfred_app/repository/session_repository.dart';
import 'package:alfred_app/repository/tasks_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(
    ref.read(authAPIProvider),
    ref.read(sessionsStoreProvider),
  ),
);

final tasksRepositoryProvider = Provider<TasksRepository>(
  (ref) => TasksRepository(
    ref.read(tasksAPIProvider),
    ref.read(tasksStoreProvider),
  ),
);

final journalRepositoryProvider = Provider<JournalRepository>(
  (ref) => JournalRepository(
    ref.read(journalAPIProvider),
  ),
);
