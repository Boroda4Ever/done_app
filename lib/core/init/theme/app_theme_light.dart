import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'light/light_theme_interface.dart';

class AppThemeLight extends AppTheme with ILightTheme {
  static AppThemeLight? _instance;
  static AppThemeLight get instance {
    return _instance ??= AppThemeLight._init();
  }

  AppThemeLight._init();

  @override
  ThemeData get theme => ThemeData();

  TabBarTheme get tabBarTheme {
    return const TabBarTheme();
  }

  TextTheme textTheme() {
    return ThemeData.light().textTheme.apply();
  }

  // ColorScheme get _appColorScheme {
  //   return ColorScheme();
  // }
}
