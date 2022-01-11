import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

// App main color
final MaterialColor jellyLightPurple =
    MaterialColor(0xFFa95dc3, jellyLightPurpleMap);
final MaterialColor jellyLightBLue =
    MaterialColor(0xFF04a2db, jellyLightBlueMap);
final MaterialColor jellyDarkPurple =
    MaterialColor(0xFF3E2247, jellyDarkPurpleMap);
final MaterialColor jellyDarkBlue = MaterialColor(0xFF003C50, jellyDarkBlueMap);
final MaterialColor jellyPurple = MaterialColor(0xFF825191, jellyPurpleMap);

// Shimmering color
final Color shimmerColor1 = Colors.grey.shade500.withAlpha(150);
final Color shimmerColor2 = Colors.grey.shade200.withAlpha(150);

// components colors
final Color cardBackgroundColor = Colors.white;

Map<int, Color> jellyPurpleMap = {
  50: Color.fromRGBO(130, 81, 145, .1),
  100: Color.fromRGBO(130, 81, 145, .2),
  200: Color.fromRGBO(130, 81, 145, .3),
  300: Color.fromRGBO(130, 81, 145, .4),
  400: Color.fromRGBO(130, 81, 145, .5),
  500: Color.fromRGBO(130, 81, 145, .6),
  600: Color.fromRGBO(130, 81, 145, .7),
  700: Color.fromRGBO(130, 81, 145, .8),
  800: Color.fromRGBO(130, 81, 145, .9),
  900: Color.fromRGBO(130, 81, 145, 1),
};

Map<int, Color> jellyDarkPurpleMap = {
  50: Color.fromRGBO(62, 34, 71, .1),
  100: Color.fromRGBO(62, 34, 71, .2),
  200: Color.fromRGBO(62, 34, 71, .3),
  300: Color.fromRGBO(62, 34, 71, .4),
  400: Color.fromRGBO(62, 34, 71, .5),
  500: Color.fromRGBO(62, 34, 71, .6),
  600: Color.fromRGBO(62, 34, 71, .7),
  700: Color.fromRGBO(62, 34, 71, .8),
  800: Color.fromRGBO(62, 34, 71, .9),
  900: Color.fromRGBO(62, 34, 71, 1),
};

Map<int, Color> jellyDarkBlueMap = {
  50: Color.fromRGBO(0, 60, 80, .1),
  100: Color.fromRGBO(0, 60, 80, .2),
  200: Color.fromRGBO(0, 60, 80, .3),
  300: Color.fromRGBO(0, 60, 80, .4),
  400: Color.fromRGBO(0, 60, 80, .5),
  500: Color.fromRGBO(0, 60, 80, .6),
  600: Color.fromRGBO(0, 60, 80, .7),
  700: Color.fromRGBO(0, 60, 80, .8),
  800: Color.fromRGBO(0, 60, 80, .9),
  900: Color.fromRGBO(0, 60, 80, 1),
};

Map<int, Color> jellyLightPurpleMap = {
  50: Color.fromRGBO(169, 93, 195, .1),
  100: Color.fromRGBO(169, 93, 195, .2),
  200: Color.fromRGBO(169, 93, 195, .3),
  300: Color.fromRGBO(169, 93, 195, .4),
  400: Color.fromRGBO(169, 93, 195, .5),
  500: Color.fromRGBO(169, 93, 195, .6),
  600: Color.fromRGBO(169, 93, 195, .7),
  700: Color.fromRGBO(169, 93, 195, .8),
  800: Color.fromRGBO(169, 93, 195, .9),
  900: Color.fromRGBO(169, 93, 195, 1),
};

Map<int, Color> jellyLightBlueMap = {
  50: Color.fromRGBO(4, 162, 219, .1),
  100: Color.fromRGBO(4, 162, 219, .2),
  200: Color.fromRGBO(4, 162, 219, .3),
  300: Color.fromRGBO(4, 162, 219, .4),
  400: Color.fromRGBO(4, 162, 219, .5),
  500: Color.fromRGBO(4, 162, 219, .6),
  600: Color.fromRGBO(4, 162, 219, .7),
  700: Color.fromRGBO(4, 162, 219, .8),
  800: Color.fromRGBO(4, 162, 219, .9),
  900: Color.fromRGBO(4, 162, 219, 1),
};

class Theme {
  static final ThemeData defaultThemeData = ThemeData(
      primaryColor: Colors.white,
      primaryColorDark: Colors.grey.shade900,
      primaryColorLight: Colors.white.withAlpha(220),
      primarySwatch: jellyPurple,
      primaryIconTheme: IconThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.grey.shade900,
      scaffoldBackgroundColor: Colors.grey.shade900,
      bottomAppBarColor: Colors.grey.shade900,
      dialogBackgroundColor: Colors.grey.shade900,
      tabBarTheme: TabBarTheme(
          indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: jellyPurple),
        ),
      )),
      snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.grey.shade900,
          contentTextStyle: TextStyle(fontSize: 18, color: Colors.white)),
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: jellyLightBLue,
          selectionColor: jellyLightBLue.withAlpha(50)),
      colorScheme: ColorScheme(
        background: Colors.grey.shade900,
        brightness: Brightness.dark,
        onBackground: Colors.white.withAlpha(230),
        error: Colors.red,
        onError: Colors.grey.shade900,
        primary: Colors.white,
        onPrimary: Colors.grey.shade900,
        secondary: jellyPurple,
        onSecondary: Colors.white,
        surface: Colors.grey.shade700,
        onSurface: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          filled: false,
          hintStyle: TextStyle(color: Colors.black)),
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          actionsIconTheme: IconThemeData(color: Colors.white),
          foregroundColor: Colors.white.withAlpha(220),
          titleTextStyle: TextStyle(
              color: Colors.white.withAlpha(220),
              fontFamily: 'Poppins',
              fontSize: 26)),
      dialogTheme: DialogTheme(
          backgroundColor: Colors.grey.shade900,
          titleTextStyle: TextStyle(
              color: Colors.white.withAlpha(220),
              fontFamily: 'Poppins',
              fontSize: 24),
          elevation: 4),
      visualDensity: VisualDensity.standard,
      cardTheme: CardTheme(
          color: Colors.white,
          shadowColor: ColorUtil.darken(Colors.grey.shade900, 0.01)),
      useMaterial3: true,
      primaryTextTheme: getTextThemeWithColor(Colors.white),
      textTheme: getTextThemeWithColor(Colors.white));

  static TextTheme getTextThemeWithColor(Color color) {
    return TextTheme(
        headline1: TextStyle(color: color, fontFamily: 'Poppins', fontSize: 38),
        headline2: TextStyle(color: color, fontFamily: 'Poppins', fontSize: 34),
        headline3: TextStyle(
            color: color.withAlpha(240), fontFamily: 'Poppins', fontSize: 30),
        headline4: TextStyle(
            color: color.withAlpha(230), fontFamily: 'Poppins', fontSize: 26),
        headline5: TextStyle(
            color: color.withAlpha(230), fontFamily: 'Poppins', fontSize: 24),
        headline6: TextStyle(
            color: color.withAlpha(220), fontFamily: 'Poppins', fontSize: 22),
        bodyText1: TextStyle(
            color: color.withAlpha(220),
            fontFamily: 'HindMadurai',
            fontSize: 22),
        bodyText2: TextStyle(
            color: color.withAlpha(220),
            fontFamily: 'HindMadurai',
            fontSize: 16),
        subtitle1: TextStyle(
            color: color.withAlpha(220),
            fontFamily: 'HindMadurai',
            fontSize: 20),
        subtitle2: TextStyle(
            color: color.withAlpha(220),
            fontFamily: 'HindMadurai',
            fontSize: 18));
  }
}
