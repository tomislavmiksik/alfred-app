import 'package:alfred_app/common/loading.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingDialog {
  static init() {
    EasyLoading.instance
      ..maskColor = AppColors.colorPrimaryBackground.withOpacity(0.95)
      ..maskType = EasyLoadingMaskType.custom
      ..boxShadow = []
      ..loadingStyle = EasyLoadingStyle.custom
      ..textColor = Colors.transparent
      ..indicatorColor = Colors.transparent
      ..progressColor = Colors.transparent
      ..backgroundColor = Colors.transparent;
    return EasyLoading.init();
  }

  static Future<void> show({
    String? message,
    Color barrierColor = Colors.white,
    double barrierOpacity = 0.95,
    bool barrierDismissible = false,
    bool useRootNavigator = true,
    String? barrierLabel,
    bool useSafeArea = true,
  }) async {
    return EasyLoading.show(
      indicator: Loading(
        message: message,
      ),
    );
  }

  static Future<void> dismiss() async {
    return EasyLoading.dismiss();
  }
}
