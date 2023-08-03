import 'package:alfred_app/flow/home/home_screen.dart';
import 'package:alfred_app/flow/login/login_screen.dart';
import 'package:alfred_app/navigation/guards/auth_guard.dart';
import 'package:auto_route/auto_route.dart';

@MaterialAutoRouter(replaceInRouteName: 'Screen,Route', routes: [
  AutoRoute(path: '/', page: HomeScreen, initial: true, guards: [
    AuthGuard,
  ]),
  AutoRoute(path: '/login', page: LoginScreen),
])
class $AppRouter {}
