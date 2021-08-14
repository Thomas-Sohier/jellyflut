import 'package:flutter/material.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;
import 'package:palette_generator/palette_generator.dart';

class Luminance {
  static ThemeData computeLuminance(List<PaletteColor> paletteColors) {
    final backgroundColor = paletteColors.elementAt(0).color;
    final fontColor = backgroundColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white70;

    return personnal_theme.Theme.defaultThemeData.copyWith(
        backgroundColor: backgroundColor,
        textTheme: personnal_theme.Theme.getTextThemeWithColor(fontColor));
  }
}
