import 'package:alfred_app/theme/default.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _AppTheme {
  ThemeData data;

  _AppTheme({required this.data});
}

class _ThemeNotifier extends StateNotifier<_AppTheme> {
  _ThemeNotifier() : super(_AppTheme(data: DefaultAppTheme().data));
}

final themeProvider =
    StateNotifierProvider<_ThemeNotifier, _AppTheme>((ref) => _ThemeNotifier());
