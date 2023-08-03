import 'dart:developer';

import 'package:alfred_app/domain/remote/auth_api.dart';

class SessionRepository {
  final AuthAPI _authAPI;

  const SessionRepository(this._authAPI);

  Future<void> saveSession(String token) async {}

  Future<void> login(String email, String password) async {
    final res = await _authAPI.login(email: email, password: password);

    log(res.toString());
  }
}
