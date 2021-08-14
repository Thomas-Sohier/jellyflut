import 'package:flutter/material.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:palette_generator/palette_generator.dart';

class Luminance {
  static ThemeData computeLuminance(List<PaletteColor> paletteColors) {
    final backgroundColor = paletteColors.elementAt(0).color;
    final fontColor = backgroundColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white70;

    return defaultThemeData.copyWith(
        backgroundColor: backgroundColor,
        textTheme: TextTheme(
          headline1: TextStyle(
              color: fontColor.withAlpha(250),
              fontFamily: 'Poppins',
              fontSize: 42),
          headline2: TextStyle(
              color: fontColor.withAlpha(240),
              fontFamily: 'Poppins',
              fontSize: 38),
          headline3: TextStyle(
              color: fontColor.withAlpha(230),
              fontFamily: 'Poppins',
              fontSize: 34),
          headline4: TextStyle(
              color: fontColor.withAlpha(220),
              fontFamily: 'Poppins',
              fontSize: 30),
          headline5: TextStyle(
              color: fontColor.withAlpha(220),
              fontFamily: 'Poppins',
              fontSize: 28),
          headline6: TextStyle(
              color: fontColor.withAlpha(220),
              fontFamily: 'Poppins',
              fontSize: 26),
          bodyText1: TextStyle(
              color: fontColor.withAlpha(210),
              fontFamily: 'HindMadurai',
              fontSize: 22),
          bodyText2: TextStyle(
              color: fontColor.withAlpha(210),
              fontFamily: 'HindMadurai',
              fontSize: 18),
        ));
  }
}
