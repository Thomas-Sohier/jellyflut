import 'package:flutter/material.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;

class Luminance {
  static ThemeData computeLuminance(Color dominantColor) {
    final fontColor =
        dominantColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    final colorScheme = ColorScheme.fromSeed(seedColor: dominantColor);
    return ThemeProvider()
        .getThemeData
        .copyWith(backgroundColor: dominantColor)
        .copyWith(colorScheme: colorScheme)
        .copyWith(primaryColor: fontColor)
        .copyWith(
            textTheme: personnal_theme.Theme.getTextThemeWithColor(fontColor));
  }
}
