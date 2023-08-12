import 'package:alfred_app/domain/data/session.dart';
import 'package:alfred_app/providers/repository_providers.dart';
import 'package:alfred_app/repository/session_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sessionNotifierProvider =
    StateNotifierProvider.autoDispose<SessionNotifier, AsyncValue<Session?>>(
  (ref) => SessionNotifier(
    ref.read(sessionRepositoryProvider),
  ),
);

class SessionNotifier extends StateNotifier<AsyncValue<Session?>> {
  final SessionRepository _sessionRepository;

  SessionNotifier(this._sessionRepository) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final session = await _sessionRepository.fetchUser();
    state = AsyncValue.data(session);
  }

  Future<void> logout() async {
    await _sessionRepository.logout();
    state = const AsyncValue.data(null);
  }
}
