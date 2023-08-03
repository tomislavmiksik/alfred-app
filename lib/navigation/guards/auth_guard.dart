import 'package:alfred_app/navigation/app_router.gr.dart';
import 'package:alfred_app/repository/session_repository.dart';
import 'package:auto_route/auto_route.dart';

class AuthGuard extends AutoRouteGuard {
  final SessionRepository _sessionRepository;

  AuthGuard(this._sessionRepository);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    router.replaceAll([const LoginRoute()]);
  }
}
