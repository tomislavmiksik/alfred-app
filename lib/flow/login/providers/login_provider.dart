import 'package:alfred_app/providers/repository_providers.dart';
import 'package:alfred_app/repository/session_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final loginProvider = ChangeNotifierProvider<LoginProvider>(
  (ref) => LoginProvider(
    ref.read(sessionRepositoryProvider),
  ),
);

class LoginProvider extends ChangeNotifier {
  final SessionRepository _sessionRepository;

  LoginProvider(this._sessionRepository);

  Future<void> login(String email, String password) async {
    await _sessionRepository.login(email, password);
  }
}
