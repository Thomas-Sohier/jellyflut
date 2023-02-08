import 'package:flutter/material.dart';

class DetailsTheme {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color onBackground;
  final Color onGradientBackground;

  const DetailsTheme(
      {required this.primary,
      required this.secondary,
      required this.tertiary,
      required this.onBackground,
      required this.onGradientBackground});

  factory DetailsTheme.empty() {
    return DetailsTheme(
        primary: Colors.black,
        secondary: Colors.black,
        tertiary: Colors.black,
        onBackground: Colors.white,
        onGradientBackground: Colors.white);
  }

  factory DetailsTheme.fromColorScheme({required ColorScheme colorScheme}) {
    return DetailsTheme(
        primary: colorScheme.primary,
        secondary: colorScheme.secondary,
        tertiary: colorScheme.tertiary,
        onBackground: colorScheme.onBackground,
        onGradientBackground: colorScheme.onSecondary);
  }
}

extension ThemeDataExtensions on ThemeData {
  static final Map<ColorScheme, DetailsTheme> _detailsTheme = {};

  void addOwn({DetailsTheme? detailsTheme}) {
    if (detailsTheme != null) _detailsTheme[colorScheme] = detailsTheme;
  }

  static DetailsTheme? empty;

  DetailsTheme ownDetailsTheme() {
    var o = _detailsTheme[colorScheme];
    if (o == null) {
      empty ??= DetailsTheme.fromColorScheme(colorScheme: colorScheme);
      o = empty;
    }
    return o!;
  }
}

DetailsTheme ownDetailsTheme(BuildContext context) => Theme.of(context).ownDetailsTheme();
