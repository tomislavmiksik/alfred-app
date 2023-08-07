import 'package:alfred_app/domain/data/session.dart';
import 'package:alfred_app/providers/repository_providers.dart';
import 'package:alfred_app/repository/session_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sessionNotifierProvider =
    StateNotifierProvider.autoDispose<SessionNotifier, Session?>(
  (ref) => SessionNotifier(
    ref.read(sessionRepositoryProvider),
  ),
);

class SessionNotifier extends StateNotifier<Session?> {
  final SessionRepository _sessionRepository;

  SessionNotifier(this._sessionRepository) : super(null) {
    _init();
  }

  Future<void> _init() async {
    final session = await _sessionRepository.getCurrentSession();
    state = session;
  }

  Future<void> logout() async {
    await _sessionRepository.logout();
    state = null;
  }
}
