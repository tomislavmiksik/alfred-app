import 'package:alfred_app/domain/local/session_store.dart';
import 'package:alfred_app/domain/local/tasks_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sessionsStoreProvider = Provider<SessionStore>(
  (ref) => SessionStore(),
);

final tasksStoreProvider = Provider<TasksStore>(
  (ref) => TasksStore(),
);
