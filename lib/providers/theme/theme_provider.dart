import 'package:flutter/material.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String THEME_KEY = 'theme_brightness';
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
    // save colors preferences, even if this is async,
    // it's fast enough so end user do not see change
    SharedPreferences.getInstance().then((sharedPreferences) {
      if (sharedPreferences.containsKey(THEME_KEY)) {
        final brightnessName = sharedPreferences.getString(THEME_KEY);
        final brightness =
            Brightness.values.firstWhere((e) => e.name == brightnessName);
        _themeData = personnal_theme.Theme.generateThemeData(brightness);
      } else {
        // Set default
        _themeData = personnal_theme.Theme.generateThemeData(Brightness.light);
      }
      _themeMode = _themeData.colorScheme.brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;

      notifyListeners();
    });

    _themeData = personnal_theme.Theme.generateThemeData(Brightness.light);
    _themeMode = _themeData.colorScheme.brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;

    notifyListeners();
  }

  void toggleTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final brightness = _themeData.colorScheme.brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
    _themeData = personnal_theme.Theme.generateThemeData(brightness);
    await sharedPreferences.setString(THEME_KEY, brightness.name);
    notifyListeners();
  }
}
