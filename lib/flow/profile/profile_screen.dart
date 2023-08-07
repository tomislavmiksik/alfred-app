import 'package:alfred_app/generated/colors.gen.dart';
import 'package:alfred_app/hooks/translation_hook.dart';
import 'package:alfred_app/navigation/app_router.dart';
import 'package:alfred_app/providers/session_provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();
    final user = ref.watch(sessionNotifierProvider)?.user;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            t.profileScreenTitle,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.normal,
            ),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: AppColors.colorPrimary,
              width: 1,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await ref.read(sessionNotifierProvider.notifier).logout();
                AutoRouter.of(context).replaceAll([const LoginRoute()]);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            MultiSliver(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.colorPrimary,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.person,
                    size: 128,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${user?.firstName ?? 'Tomislav'} ${user?.lastName ?? 'Miksik'}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      user?.email ?? '',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
