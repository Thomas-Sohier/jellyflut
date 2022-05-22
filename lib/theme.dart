import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Shimmering color
final Color shimmerColor1 = Colors.grey.shade500.withAlpha(150);
final Color shimmerColor2 = Colors.grey.shade200.withAlpha(150);

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
  static ThemeData generateThemeData(
      [Brightness brightness = Brightness.light, Color? seedColor]) {
    seedColor ??= jellyLightPurpleMap[500]!;
    final background =
        brightness == Brightness.light ? null : Colors.grey.shade900;
    final theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: brightness,
          background: background,
        ),
        visualDensity: VisualDensity.standard,
        useMaterial3: true);
    final textTheme = getTextThemeWithColor(theme.colorScheme.onBackground);

    return theme
        .copyWith(textTheme: textTheme)
        .copyWith(scaffoldBackgroundColor: theme.colorScheme.background)
        .copyWith(backgroundColor: theme.backgroundColor)
        .copyWith(
            dialogTheme: DialogTheme(
                backgroundColor: theme.colorScheme.background,
                titleTextStyle: textTheme.headline4,
                contentTextStyle: textTheme.bodyText1))
        .copyWith(
            appBarTheme: AppBarTheme(
                color: theme.colorScheme.background,
                foregroundColor: theme.colorScheme.onBackground,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarBrightness: theme.brightness,
                  statusBarIconBrightness: theme.brightness,
                  statusBarColor: theme.colorScheme.background,
                  systemNavigationBarColor: theme.colorScheme.background,
                  systemNavigationBarContrastEnforced: false,
                ),
                toolbarTextStyle: theme.textTheme.headline5,
                titleTextStyle: theme.textTheme.headline5))
        .copyWith(
            snackBarTheme: SnackBarThemeData(
                behavior: SnackBarBehavior.floating,
                backgroundColor: theme.colorScheme.background,
                contentTextStyle: TextStyle(
                    fontSize: 18, color: theme.colorScheme.onSurface)))
        .copyWith(
            iconTheme: IconThemeData(color: theme.colorScheme.onBackground))
        .copyWith(
            tabBarTheme: TabBarTheme(
                labelColor: theme.colorScheme.onBackground,
                labelStyle: theme.textTheme.headline5,
                indicator: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: theme.colorScheme.primary)))))
        .copyWith(
            drawerTheme:
                DrawerThemeData(backgroundColor: theme.colorScheme.background))
        .copyWith(
            inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.colorScheme.onBackground, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                disabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.red.shade400, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.colorScheme.onBackground, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.colorScheme.onBackground, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                filled: false,
                isDense: true,
                prefixIconColor: theme.colorScheme.onBackground,
                suffixIconColor: theme.colorScheme.onBackground,
                labelStyle: TextStyle(color: theme.colorScheme.onBackground),
                floatingLabelStyle:
                    TextStyle(color: theme.colorScheme.onBackground),
                hintStyle: TextStyle(color: theme.colorScheme.onBackground)))
        .copyWith(cardTheme: CardTheme(color: theme.colorScheme.background));
  }

  static TextTheme getTextThemeWithColor([Color? color]) {
    final poppinsFont = TextStyle(fontFamily: 'Poppins', color: color);
    final hindMaduraiFont = TextStyle(fontFamily: 'HindMadurai', color: color);
    return Typography.blackCupertino
        .copyWith(headline1: poppinsFont)
        .copyWith(headline2: poppinsFont)
        .copyWith(headline3: poppinsFont)
        .copyWith(headline4: poppinsFont)
        .copyWith(headline5: poppinsFont)
        .copyWith(headline6: poppinsFont)
        .copyWith(subtitle1: poppinsFont)
        .copyWith(subtitle2: poppinsFont)
        .copyWith(bodyLarge: hindMaduraiFont.copyWith(fontSize: 18))
        .copyWith(bodyMedium: hindMaduraiFont.copyWith(fontSize: 16))
        .copyWith(bodySmall: hindMaduraiFont.copyWith(fontSize: 14))
        .copyWith(titleLarge: hindMaduraiFont)
        .copyWith(titleMedium: hindMaduraiFont)
        .copyWith(titleSmall: hindMaduraiFont)
        .copyWith(bodyText1: hindMaduraiFont.copyWith(fontSize: 18))
        .copyWith(bodyText2: hindMaduraiFont.copyWith(fontSize: 16))
        .copyWith(button: hindMaduraiFont.copyWith(fontSize: 16))
        .apply(bodyColor: color)
        .apply(displayColor: color)
        .apply(decorationColor: color);
  }
}
