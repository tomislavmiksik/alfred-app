import 'package:alfred_app/generated/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppReactiveTextField extends ReactiveTextField {
  AppReactiveTextField({
    super.key,
    required String label,
    required String formControlName,
  }) : super(
          formControlName: formControlName,
          decoration: InputDecoration(
              label: Text(label),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.colorPrimary,
                ),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.colorPrimary,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.colorPrimary,
                ),
              )),
        );
}
