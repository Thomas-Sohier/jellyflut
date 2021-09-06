import 'package:flutter/material.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;

class Luminance {
  static ThemeData computeLuminance(Color dominantColor) {
    final fontColor = dominantColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white70;

    return personnal_theme.Theme.defaultThemeData
        .copyWith(backgroundColor: dominantColor)
        .copyWith(
            textTheme: personnal_theme.Theme.getTextThemeWithColor(fontColor))
        .copyWith(primaryColor: fontColor);
  }
}
