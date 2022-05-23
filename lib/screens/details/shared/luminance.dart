import 'package:flutter/material.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;

class Luminance {
  static ThemeData computeLuminance(Color dominantColor) {
    final brightness = dominantColor.computeLuminance() > 0.5
        ? Brightness.light
        : Brightness.dark;
    return personnal_theme.Theme.generateThemeDataFromSeedColor(
        brightness, dominantColor);
  }
}
