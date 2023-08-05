import 'package:alfred_app/generated/colors.gen.dart';
import 'package:alfred_app/navigation/app_router.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = useState(1);
    return Scaffold(
      body: AutoTabsScaffold(
        animationCurve: Curves.easeInOut,
        routes: const [
          ProfileRoute(),
        ],
        bottomNavigationBuilder: (context, _) {
          return AnimatedBottomNavigationBar(
            blurEffect: true,
            gapLocation: GapLocation.none,
            icons: const [
              Icons.person_2_outlined,
              Icons.settings_outlined,
              Icons.home_outlined,
              Icons.person_outline
            ],
            activeColor: AppColors.colorPrimary,
            activeIndex: activeIndex.value,
            onTap: (index) {
              activeIndex.value = index;
              // context.router.push(
              //   const ProfileRoute(),
              // );
            },
          );
        },
      ),
    );
  }
}
