import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _fallbackSettings = RouteSettings(name: 'dialogs');

abstract class AppDialog extends HookWidget {
  final Widget child;

  AppDialog({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Future<T?> show<T>(
    BuildContext context, {
    RouteSettings routeSettings = _fallbackSettings,
    bool barrierDismissible = false,
    double barrierOpacity = 0.85,
  }) async {
    return await showDialog<T>(
      useRootNavigator: true,
      routeSettings: routeSettings,
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withOpacity(barrierOpacity),
      builder: (context) => this,
    );
  }

  Future<void> dismiss(
    BuildContext context, {
    RouteSettings settings = _fallbackSettings,
  }) async {
    Navigator.of(context).popUntil(
      (route) => route.settings.name != settings.name,
    );
  }

  static void dismissAll(BuildContext context) {
    Navigator.of(context, rootNavigator: true).popUntil(
      (route) => route.settings.name != _fallbackSettings.name,
    );
  }
}
