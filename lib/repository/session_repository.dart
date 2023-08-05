import 'package:alfred_app/domain/data/session.dart';
import 'package:alfred_app/domain/local/session_store.dart';
import 'package:alfred_app/domain/remote/auth_api.dart';

class SessionRepository {
  final AuthAPI _authAPI;
  final SessionStore _sessionStore;

  const SessionRepository(this._authAPI, this._sessionStore);

  Future<void> saveSession(String token) async {}

  Future<void> login(String email, String password) async {
    final res = await _authAPI.login(email: email, password: password);

    await _sessionStore.setCurrentSession(res);
  }

  Future<Session?> getCurrentSession() async {
    return await _sessionStore.getCurrentSession();
  }
}
