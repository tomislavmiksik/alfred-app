import 'package:alfred_app/navigation/app_router.dart';
import 'package:alfred_app/navigation/guards/auth_guard.dart';
import 'package:alfred_app/providers/repository_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authGuardProvider = Provider(
  (ref) => AuthGuard(
    ref.read(sessionRepositoryProvider),
  ),
);
final appRouterProvider = Provider(
  (ref) => AppRouter(
    authGuard: ref.read(authGuardProvider),
  ),
);
