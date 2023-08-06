import 'package:alfred_app/flow/tasks/widgets/add_task_dialog.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:alfred_app/hooks/translation_hook.dart';
import 'package:alfred_app/navigation/app_router.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final tabIcons = const [
    Icons.menu_book_outlined,
    Icons.task_alt_sharp,
    Icons.event_outlined,
    Icons.person_2_outlined,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();

    return Scaffold(
      body: AutoTabsScaffold(
        floatingActionButton: SpeedDial(
          overlayColor: Colors.black12,
          animationCurve: Curves.easeInOut,
          childPadding: const EdgeInsets.all(8),
          animatedIcon: AnimatedIcons.menu_close,
          spaceBetweenChildren: 8,
          switchLabelPosition: true,
          children: [
            SpeedDialChild(
              labelBackgroundColor: AppColors.colorBackgroundPopUp,
              labelShadow: null,
              labelWidget: Text(
                t.addTask,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.colorBackgroundPopUp,
              child: const Icon(
                Icons.add_task_outlined,
                color: Colors.white,
              ),
              onTap: () => const AddTaskDialog().show(context),
            ),
            SpeedDialChild(
              labelBackgroundColor: AppColors.colorBackgroundPopUp,
              labelShadow: null,
              labelWidget: Text(
                t.addEvent,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.colorBackgroundPopUp,
              child: const Icon(
                Icons.event,
                color: Colors.white,
              ),
              //onTap: () => context.router.push(const AddTaskRoute())
            ),
            SpeedDialChild(
              labelBackgroundColor: AppColors.colorBackgroundPopUp,
              labelShadow: null,
              labelWidget: Text(
                t.addJournalEntry,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.colorBackgroundPopUp,
              child: const Icon(
                Icons.note_add_outlined,
                color: Colors.white,
              ),
              //onTap: () => context.router.push(const AddTaskRoute())
            )
          ],
          backgroundColor: AppColors.colorPrimary,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        animationCurve: Curves.easeInOut,
        routes: const [
          JournalRoute(),
          TasksRoute(),
          EventRoute(),
          ProfileRoute(),
        ],
        bottomNavigationBuilder: (context, tabsRouter) {
          return AnimatedBottomNavigationBar.builder(
            itemCount: tabsRouter.pageCount,
            backgroundColor: AppColors.colorBackgroundPopUp,
            gapLocation: GapLocation.center,
            notchAndCornersAnimation: null,
            splashColor: Colors.transparent,
            notchSmoothness: NotchSmoothness.softEdge,
            splashRadius: 0,
            activeIndex: tabsRouter.activeIndex,
            onTap: (index) => tabsRouter.setActiveIndex(index),
            tabBuilder: (int index, bool isActive) {
              return Icon(
                tabIcons[index],
                size: 24,
                color: isActive ? AppColors.colorPrimary : Colors.white,
              );
            },
          );
        },
      ),
    );
  }
}
