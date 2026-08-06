import 'package:flutter/material.dart';
import 'package:test_task/app/theme/app_theme.dart';

extension ThemeContextExtensions on BuildContext {
  AppThemeColors get appColors => Theme.of(this).extension<AppThemeColors>()!;

  TextTheme get textTheme => Theme.of(this).textTheme;
}
