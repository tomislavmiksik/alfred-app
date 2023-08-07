import 'package:alfred_app/flow/events/event_screen.dart';
import 'package:alfred_app/flow/home/home_screen.dart';
import 'package:alfred_app/flow/journal/journal_screen.dart';
import 'package:alfred_app/flow/login/login_screen.dart';
import 'package:alfred_app/flow/profile/profile_screen.dart';
import 'package:alfred_app/flow/register/register_screen.dart';
import 'package:alfred_app/flow/tasks/tasks_screen.dart';
import 'package:alfred_app/navigation/guards/auth_guard.dart';
import 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Screen,Route',
)
class AppRouter extends _$AppRouter {
  final AuthGuard authGuard;

  AppRouter({required this.authGuard});

  @override
  RouteType get defaultRouteType => const RouteType.material();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
          guards: [
            authGuard,
          ],
          children: [
            AutoRoute(
              page: ProfileRoute.page,
              path: 'profile',
            ),
            AutoRoute(
              page: TasksRoute.page,
              path: 'tasks',
            ),
            AutoRoute(
              page: JournalRoute.page,
              path: 'journal',
            ),
            AutoRoute(
              page: EventRoute.page,
              path: 'events',
            )
          ],
        ),
        AutoRoute(
          path: '/login',
          page: LoginRoute.page,
        ),
        AutoRoute(
          path: '/register',
          page: RegisterRoute.page,
        )
      ];
}
