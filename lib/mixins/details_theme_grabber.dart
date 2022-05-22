import 'package:flutter/material.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;

/// This mixin allow to get application Theme
/// Useful for dialog, button and others that are located inside details pages
/// which use dynamic theming
mixin AppThemeGrabber<T extends StatefulWidget> on State<T> {
  late final ThemeProvider _themeProvider;
  late ThemeData _themedata;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
  }

  @override
  void didChangeDependencies() {
    _themedata = _themeProvider.getThemeData;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ThemeData get getThemeData => _themedata;
}
