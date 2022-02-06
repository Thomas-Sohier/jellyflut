import 'package:flutter/material.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;

class ThemeProvider extends ChangeNotifier {
  late ThemeMode _themeMode;
  late ThemeData _themeData;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  ThemeMode get getThemeMode => _themeMode;
  ThemeData get getThemeData => _themeData;

  // Singleton
  static final ThemeProvider _ThemeProvider = ThemeProvider._internal();

  factory ThemeProvider() {
    return _ThemeProvider;
  }

  ThemeProvider._internal() {
    _themeData = personnal_theme.Theme.generateThemeData(Brightness.light);
    _themeMode = _themeData.colorScheme.brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final brightness = _themeData.colorScheme.brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
    _themeData = personnal_theme.Theme.generateThemeData(brightness);
    notifyListeners();
  }
}
