import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:material_color_utilities/material_color_utilities.dart' as m;

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
  static ThemeData generateThemeFromSeedColor(Color dominantColor) {
    final brightness = dominantColor.computeLuminance() > 0.5
        ? Brightness.light
        : Brightness.dark;
    return generateThemeDataFromSeedColor(brightness, dominantColor);
  }

  static ThemeData generateThemeFromColors(Color primary, Color secondary) {
    final middleColor = Color.lerp(primary, secondary, 0.5)!;
    final brightness = middleColor.computeLuminance() > 0.5
        ? Brightness.light
        : Brightness.dark;
    return generateThemeDataFromSwatchColor(brightness, primary, secondary);
  }

  /// Generate a theme from a colorScheme
  /// You can provide a [brightness] if needed (by default -> Brightness.light), it will override colorscheme's one
  /// You need to provide a [colorScheme]
  static ThemeData generateThemeDataFromColorScheme(ColorScheme colorScheme,
      [Brightness? brightness]) {
    final newBrightness = brightness ?? colorScheme.brightness;
    final background =
        newBrightness == Brightness.light ? null : Colors.grey.shade900;
    final newColorScheme = ColorScheme.fromSeed(
        seedColor: colorScheme.primary,
        brightness: newBrightness,
        background: background);
    final theme = ThemeData(
        colorScheme: newColorScheme,
        visualDensity: VisualDensity.standard,
        useMaterial3: true);
    return _generateTheme(theme);
  }

  /// Generate a theme from a colorScheme
  /// You can provide a [brightness] if needed (by default -> Brightness.light)
  /// You can provide a [seedColor] if needed (by default -> jellyfin purple color)
  static ThemeData generateThemeDataFromSeedColor(
      [Brightness brightness = Brightness.light, Color? seedColor]) {
    final background =
        brightness == Brightness.light ? null : Colors.grey.shade900;
    final theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor ?? jellyLightPurpleMap[500]!,
            brightness: brightness,
            background: background),
        visualDensity: VisualDensity.standard,
        useMaterial3: true);
    return _generateTheme(theme);
  }

  /// Generate a theme from a colorScheme
  /// You can provide a [brightness] if needed (by default -> Brightness.light)
  /// You can provide a [seedColor] if needed (by default -> jellyfin purple color)
  static ThemeData generateThemeDataFromSwatchColor(
      [Brightness brightness = Brightness.light,
      Color? primary,
      Color? secondary]) {
    final background =
        brightness == Brightness.light ? null : Colors.grey.shade900;
    primary ??= jellyLightPurpleMap[500]!;
    secondary ??= jellyLightBlueMap[500]!;
    final primarySwatch = ColorUtil.colorToMaterialColor(primary);
    final colorScheme = ColorScheme.fromSwatch(
        primarySwatch: primarySwatch,
        accentColor: secondary,
        brightness: brightness,
        backgroundColor: background);
    final theme = ThemeData(
        colorScheme:
            colorScheme.copyWith(onBackground: colorScheme.onSecondary),
        visualDensity: VisualDensity.standard,
        useMaterial3: true);
    return _generateTheme(theme);
  }

  /// Generate a custom theme
  /// You need to provide a [theme]
  static ThemeData _generateTheme(ThemeData theme) {
    final textTheme =
        generateTextThemeFromColor(theme.colorScheme.onBackground);
    final reveredBrightness = theme.brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
    return theme
        .copyWith(textTheme: textTheme)
        .copyWith(scaffoldBackgroundColor: theme.colorScheme.background)
        .copyWith(backgroundColor: theme.backgroundColor)
        .copyWith(
            dialogTheme: DialogTheme(
                backgroundColor: theme.colorScheme.background,
                titleTextStyle: textTheme.headline5,
                contentTextStyle: textTheme.bodyText1))
        .copyWith(
            appBarTheme: AppBarTheme(
                color: theme.colorScheme.background,
                foregroundColor: theme.colorScheme.onBackground,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarBrightness: reveredBrightness,
                  statusBarIconBrightness: reveredBrightness,
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
        .copyWith(popupMenuTheme: PopupMenuThemeData(elevation: 2))
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

  /// Generate a text theme specific to this app
  /// You can provide a [color] to specify font color
  static TextTheme generateTextThemeFromColor([Color? color]) {
    TextStyle? poppinsFont(TextStyle? textStyle) =>
        textStyle?.copyWith(fontFamily: 'Poppins', color: color);
    TextStyle? hindMaduraiFont(TextStyle? textStyle) =>
        textStyle?.copyWith(fontFamily: 'HindMadurai', color: color);
    final typography = Typography.englishLike2021;

    return typography
        .copyWith(headline1: poppinsFont(typography.headline1))
        .copyWith(headline2: poppinsFont(typography.headline2))
        .copyWith(headline3: poppinsFont(typography.headline3))
        .copyWith(headline4: poppinsFont(typography.headline4))
        .copyWith(headline5: poppinsFont(typography.headline5))
        .copyWith(headline6: poppinsFont(typography.headline6))
        .copyWith(subtitle1: poppinsFont(typography.subtitle1))
        .copyWith(subtitle2: poppinsFont(typography.subtitle2))
        .copyWith(bodyLarge: hindMaduraiFont(typography.bodyLarge))
        .copyWith(bodyMedium: hindMaduraiFont(typography.bodyMedium))
        .copyWith(bodySmall: hindMaduraiFont(typography.bodySmall))
        .copyWith(titleLarge: hindMaduraiFont(typography.titleLarge))
        .copyWith(titleMedium: hindMaduraiFont(typography.titleMedium))
        .copyWith(titleSmall: hindMaduraiFont(typography.titleSmall))
        .copyWith(bodyText1: hindMaduraiFont(typography.bodyText1))
        .copyWith(bodyText2: hindMaduraiFont(typography.bodyText2))
        .copyWith(button: hindMaduraiFont(typography.button))
        .apply(bodyColor: color)
        .apply(displayColor: color)
        .apply(decorationColor: color);
  }
}
