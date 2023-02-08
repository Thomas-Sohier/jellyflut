import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut/theme/theme_extend_own.dart';

// Shimmering color
final Color shimmerColor1 = Colors.grey.shade500.withAlpha(150);
final Color shimmerColor2 = Colors.grey.shade200.withAlpha(150);

Map<int, Color> jellyPurpleMap = ColorUtil.generateColorSwatch(Color.fromARGB(255, 130, 81, 145));
Map<int, Color> jellyBlueMap = ColorUtil.generateColorSwatch(Color.fromARGB(255, 4, 162, 219));

abstract class Theme {
  static ThemeData generateThemeFromSeedColor(Color dominantColor) {
    final brightness = dominantColor.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark;
    return generateThemeDataFromSeedColor(brightness, dominantColor);
  }

  /// Generate a theme from a colorScheme
  /// You can provide a [brightness] if needed (by default -> Brightness.light), it will override colorscheme's one
  /// You need to provide a [colorScheme]
  static ThemeData generateThemeDataFromColorScheme(ColorScheme colorScheme, [Brightness? brightness]) {
    final newBrightness = brightness ?? colorScheme.brightness;
    final background = newBrightness == Brightness.light ? null : Colors.grey.shade900;
    final newColorScheme =
        ColorScheme.fromSeed(seedColor: colorScheme.primary, brightness: newBrightness, background: background);
    final theme = ThemeData(colorScheme: newColorScheme, visualDensity: VisualDensity.standard, useMaterial3: true);
    return _generateTheme(theme);
  }

  /// Generate a theme from a colorScheme
  /// You can provide a [brightness] if needed (by default -> Brightness.light)
  /// You can provide a [seedColor] if needed (by default -> jellyfin purple color)
  static ThemeData generateThemeDataFromSeedColor([Brightness brightness = Brightness.light, Color? seedColor]) {
    // final background = brightness == Brightness.light ? null : Colors.grey.shade900;
    final theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor ?? jellyPurpleMap[500]!, brightness: brightness),
        visualDensity: VisualDensity.standard,
        useMaterial3: true);
    return _generateTheme(theme);
  }

  /// Generate a theme from a colorScheme
  /// You can provide a [brightness], only used if in contrastedPage
  /// You can provide a [seedColor] if needed (by default -> jellyfin purple color)
  static ThemeData generateDetailsThemeDataFromPaletteColor(List<Color> colors,
      [bool contastedPage = false, Brightness brightness = Brightness.dark]) {
    final palette = colors.sublist(0, min(3, colors.length));
    final middleElement = (palette.length / 2).round() - 1;
    final onBackground = palette[middleElement].computeLuminance() > 0.5 ? Colors.black : Colors.white;
    if (contastedPage) {
      final themeDataInitial = generateThemeDataFromSeedColor(brightness, palette.first);
      return themeDataInitial
        ..addOwn(
            detailsTheme: DetailsTheme(
                primary: palette[min(0, palette.length - 1)],
                secondary: palette[min(1, palette.length - 1)],
                tertiary: palette[min(2, palette.length - 1)],
                onBackground: themeDataInitial.colorScheme.onBackground,
                onGradientBackground: onBackground));
    }
    final themeDataInitial = generateThemeFromSeedColor(palette.first);
    return themeDataInitial
        .copyWith(textTheme: generateTextThemeFromColor(onBackground))
        .copyWith(colorScheme: themeDataInitial.colorScheme.copyWith(onBackground: onBackground))
      ..addOwn(
          detailsTheme: DetailsTheme(
        primary: palette[min(0, palette.length - 1)],
        secondary: palette[min(1, palette.length - 1)],
        tertiary: palette[min(2, palette.length - 1)],
        onBackground: themeDataInitial.colorScheme.onBackground,
        onGradientBackground: onBackground,
      ));
  }

  /// Generate a custom theme
  /// You need to provide a [theme]
  static ThemeData _generateTheme(ThemeData theme) {
    final textTheme = generateTextThemeFromColor(theme.colorScheme.onBackground);
    final reveredBrightness = theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    return theme
        .copyWith(textTheme: textTheme)
        .copyWith(scaffoldBackgroundColor: theme.colorScheme.background)
        .copyWith(colorScheme: theme.colorScheme)
        .copyWith(
            dialogTheme: DialogTheme(
                backgroundColor: theme.colorScheme.background,
                titleTextStyle: textTheme.headlineSmall,
                contentTextStyle: textTheme.bodyLarge))
        .copyWith(
            appBarTheme: AppBarTheme(
                color: theme.colorScheme.background,
                foregroundColor: theme.colorScheme.onBackground,
                scrolledUnderElevation: 4,
                shadowColor: Colors.black38,
                toolbarTextStyle: theme.textTheme.headlineSmall,
                titleTextStyle: theme.textTheme.headlineSmall,
                surfaceTintColor: theme.colorScheme.background,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarBrightness: reveredBrightness,
                  statusBarIconBrightness: reveredBrightness,
                  statusBarColor: theme.colorScheme.background,
                  systemNavigationBarColor: theme.colorScheme.background,
                  systemNavigationBarContrastEnforced: false,
                )))
        .copyWith(
            snackBarTheme: SnackBarThemeData(
                behavior: SnackBarBehavior.floating,
                backgroundColor: theme.colorScheme.background,
                contentTextStyle: TextStyle(fontSize: 18, color: theme.colorScheme.onSurface)))
        .copyWith(iconTheme: IconThemeData(color: theme.colorScheme.onBackground))
        .copyWith(
            tabBarTheme: TabBarTheme(
                labelColor: theme.colorScheme.onBackground,
                labelStyle: theme.textTheme.headlineSmall,
                indicator: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.primary)))))
        .copyWith(popupMenuTheme: PopupMenuThemeData(elevation: 2))
        .copyWith(drawerTheme: DrawerThemeData(backgroundColor: theme.colorScheme.background))
        .copyWith(
            inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.onBackground, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade400, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.onBackground, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.onBackground, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                filled: false,
                isDense: true,
                prefixIconColor: theme.colorScheme.onBackground,
                suffixIconColor: theme.colorScheme.onBackground,
                labelStyle: TextStyle(color: theme.colorScheme.onBackground),
                floatingLabelStyle: TextStyle(color: theme.colorScheme.onBackground),
                hintStyle: TextStyle(color: theme.colorScheme.onBackground)))
        .copyWith(cardTheme: CardTheme(color: theme.colorScheme.background));
  }

  /// Generate a text theme from a background color
  static TextTheme generateTextThemeFromBackgroundColor({required Color backgroundColor}) {
    final fontcolor = backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return generateTextThemeFromColor(fontcolor);
  }

  /// Generate a text theme specific to this app
  /// You can provide a [color] to specify font color
  static TextTheme generateTextThemeFromColor([Color? color]) {
    TextStyle? poppinsFont(TextStyle? textStyle) => textStyle?.copyWith(fontFamily: 'Poppins', color: color);
    TextStyle? hindMaduraiFont(TextStyle? textStyle) => textStyle?.copyWith(fontFamily: 'HindMadurai', color: color);
    const typography = Typography.englishLike2021;

    return typography
        .copyWith(displayLarge: poppinsFont(typography.displayLarge))
        .copyWith(displayMedium: poppinsFont(typography.displayMedium))
        .copyWith(displaySmall: poppinsFont(typography.displaySmall))
        .copyWith(headlineMedium: poppinsFont(typography.headlineMedium))
        .copyWith(headlineSmall: poppinsFont(typography.headlineSmall))
        .copyWith(titleLarge: poppinsFont(typography.titleLarge))
        .copyWith(titleMedium: poppinsFont(typography.titleMedium))
        .copyWith(titleSmall: poppinsFont(typography.titleSmall))
        .copyWith(bodyLarge: hindMaduraiFont(typography.bodyLarge))
        .copyWith(bodyMedium: hindMaduraiFont(typography.bodyMedium))
        .copyWith(bodySmall: hindMaduraiFont(typography.bodySmall))
        .copyWith(titleLarge: hindMaduraiFont(typography.titleLarge))
        .copyWith(titleMedium: hindMaduraiFont(typography.titleMedium))
        .copyWith(titleSmall: hindMaduraiFont(typography.titleSmall))
        .copyWith(bodyLarge: hindMaduraiFont(typography.bodyLarge))
        .copyWith(bodyMedium: hindMaduraiFont(typography.bodyMedium))
        .copyWith(labelLarge: hindMaduraiFont(typography.labelLarge))
        .apply(bodyColor: color)
        .apply(displayColor: color)
        .apply(decorationColor: color);
  }
}
