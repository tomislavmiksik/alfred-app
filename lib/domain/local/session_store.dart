import 'package:alfred_app/domain/data/session.dart';
import 'package:hive/hive.dart';

const _boxKey = 'sessions_store';
const _currentSessionKey = 'current_session';

class SessionStore {
  Future<Session?> getCurrentSession() async {
    final box = await Hive.openBox<Session>(_boxKey);
    return box.get(_currentSessionKey);
  }

  Future<void> setCurrentSession(Session session) async {
    final box = await Hive.openBox<Session>(_boxKey);
    await box.put(_currentSessionKey, session);
  }

  Future<void> clearCurrentSession() async {
    final box = await Hive.openBox<Session>(_boxKey);
    await box.delete(_currentSessionKey);
  }
}
