import 'package:alfred_app/providers/network_providers.dart';
import 'package:alfred_app/repository/session_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(
    ref.read(authAPIProvider),
  ),
);
