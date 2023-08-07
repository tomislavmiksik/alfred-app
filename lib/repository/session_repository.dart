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

  Future<void> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final res = await _authAPI.register(
      email: email,
      username: username,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );

    await _sessionStore.setCurrentSession(res);
  }

  Future<void> logout() async {
    await _sessionStore.clearCurrentSession();
  }

  Future<Session?> getCurrentSession() async {
    final user = await _authAPI.getCurrentUser();

    return await _sessionStore.updateCurrentSession(user);
  }
}
