import 'package:alfred_app/generated/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _routeSettings = RouteSettings(name: 'dialogs/alert');

class AlertDialog extends HookWidget {
  final String title;
  final String description;
  final String cancelText;
  final String okText;
  final Function() onOkPressed;

  const AlertDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.cancelText,
    required this.okText,
    required this.onOkPressed,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String description,
    required String cancelText,
    required String okText,
    required Function() onOkPressed,
  }) async {
    await showDialog(
      useRootNavigator: true,
      routeSettings: _routeSettings,
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => AlertDialog(
        title: title,
        description: description,
        cancelText: cancelText,
        okText: okText,
        onOkPressed: onOkPressed,
      ),
    );
  }

  static Future<void> dismiss(BuildContext context) async {
    Navigator.of(context, rootNavigator: true).popUntil(
      (route) => route.settings.name != _routeSettings.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    AlertDialog.dismiss(context);
                    onOkPressed();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorSemanticRed,
                  ),
                  child: Text(okText),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  child: Text(
                    cancelText,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () => AlertDialog.dismiss(context),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
