import 'package:alfred_app/domain/data/session.dart';
import 'package:alfred_app/domain/data/user.dart';
import 'package:hive/hive.dart';

const _boxKey = 'sessions_store';
const _currentSessionKey = 'current_session';

class SessionStore {
  Future<Session?> getCurrentSession() async {
    final box = await Hive.openBox<Session>(_boxKey);
    return box.get(_currentSessionKey);
  }

  Future<Session> updateCurrentSession(User user) async {
    final box = await Hive.openBox<Session>(_boxKey);
    final session = box.get(_currentSessionKey);
    final updatedSession = session!.copyWith(user: user);
    await box.put(_currentSessionKey, updatedSession);
    return updatedSession;
  }

  Future<void> setCurrentSession(Session session) async {
    final box = await Hive.openBox<Session>(_boxKey);
    await box.put(_currentSessionKey, session);
  }

  Future<void> clearCurrentSession() async {
    await Hive.openBox<Session>(_boxKey);
    await Hive.deleteFromDisk();
  }
}
