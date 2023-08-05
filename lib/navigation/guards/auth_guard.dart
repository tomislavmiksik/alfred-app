import 'package:alfred_app/repository/session_repository.dart';
import 'package:auto_route/auto_route.dart';

import '../app_router.dart';

class AuthGuard extends AutoRouteGuard {
  final SessionRepository _sessionRepository;

  AuthGuard(this._sessionRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final session = await _sessionRepository.getCurrentSession();

    if (session != null) {
      resolver.next(true);
      return;
    }
    router.replaceAll([const LoginRoute()]);
  }
}
