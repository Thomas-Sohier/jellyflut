import 'package:flutter/material.dart';
import 'package:jellyflut/shared/shared_prefs.dart';
import 'package:jellyflut/theme/theme.dart' as personnal_theme;

class ThemeProvider extends ChangeNotifier {
  static const String THEME_KEY = 'theme_brightness';
  static const String THEME_SEED_COLOR_KEY = 'theme_seed_color';
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
    final brightness = getBrightness();
    final primaryColor = getPrimaryColor();
    _themeData = personnal_theme.Theme.generateThemeDataFromSeedColor(brightness, primaryColor);
    _themeMode = _themeData.colorScheme.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  Color getPrimaryColor() {
    final primaryColor = SharedPrefs.sharedPrefs.getString(THEME_SEED_COLOR_KEY);
    if (primaryColor == null) {
      return personnal_theme.jellyPurpleMap[500]!;
    }

    return Color(int.parse(primaryColor));
  }

  Brightness getBrightness() {
    final brightnessName = SharedPrefs.sharedPrefs.getString(THEME_KEY);
    if (brightnessName == null) {
      SharedPrefs.sharedPrefs.setString(THEME_KEY, Brightness.dark.name);
      return Brightness.dark;
    }

    return Brightness.values.firstWhere((e) => e.name == brightnessName);
  }

  void editSeedColorTheme(Color color) async {
    final brightnessName = SharedPrefs.sharedPrefs.getString(THEME_KEY);
    final brightness = Brightness.values.firstWhere((e) => e.name == brightnessName);
    _themeData = personnal_theme.Theme.generateThemeDataFromSeedColor(brightness, color);
    await SharedPrefs.sharedPrefs.setString(THEME_SEED_COLOR_KEY, color.value.toString());
    notifyListeners();
  }

  ThemeMode switchThemeMode() {
    _themeMode = _themeData.colorScheme.brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    return _themeMode;
  }

  Brightness switchBrightness() {
    return _themeData.colorScheme.brightness == Brightness.dark ? Brightness.light : Brightness.dark;
  }

  void toggleTheme() async {
    final brightness = switchBrightness();
    final seedColor = getPrimaryColor();
    switchThemeMode();
    _themeData = personnal_theme.Theme.generateThemeDataFromSeedColor(brightness, seedColor);
    await SharedPrefs.sharedPrefs.setString(THEME_KEY, brightness.name);
    notifyListeners();
  }
}
