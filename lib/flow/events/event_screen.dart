import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class EventScreen extends HookConsumerWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      child: Text('Event Screen'),
    );
  }
}
