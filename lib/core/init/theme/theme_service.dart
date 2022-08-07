import 'package:flutter/material.dart';

import '../../constants/enums/app_theme_enum.dart';
import 'app_theme_light.dart';

class ThemeService extends ChangeNotifier {
  ThemeData _currentTheme = AppThemeLight.instance.theme;

  AppThemes _currenThemeEnum = AppThemes.light;

  AppThemes get currenThemeEnum => _currenThemeEnum;

  ThemeData get currentTheme => _currentTheme;

  void changeValue(AppThemes theme) {
    if (theme == AppThemes.light) {
      _currentTheme = ThemeData.light();
    } else {
      _currentTheme = ThemeData.dark();
    }
    notifyListeners();
  }

  void changeTheme() {
    if (_currenThemeEnum == AppThemes.light) {
      _currentTheme = ThemeData.dark();
      _currenThemeEnum = AppThemes.dark;
    } else {
      _currentTheme = AppThemeLight.instance.theme;
      ;
      _currenThemeEnum = AppThemes.light;
    }
    notifyListeners();
  }
}
