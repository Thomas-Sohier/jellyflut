import 'package:flutter/material.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;

class Luminance {
  static ThemeData computeLuminance(Color dominantColor) {
    final fontColor = dominantColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white70;

    final colorScheme = ColorScheme.fromSeed(seedColor: dominantColor);
    return personnal_theme.Theme.defaultThemeData
        .copyWith(backgroundColor: dominantColor)
        .copyWith(colorScheme: colorScheme)
        .copyWith(primaryColor: fontColor)
        .copyWith(
            textTheme: personnal_theme.Theme.getTextThemeWithColor(fontColor));
  }
}
