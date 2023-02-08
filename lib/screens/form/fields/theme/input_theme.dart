import 'package:flutter/material.dart';

class InputTheme {
  late final BuildContext _context;

  InputBorder get DEFAULT_BORDER => OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: Theme.of(_context).colorScheme.onBackground.withOpacity(0.9)));
  InputBorder get FOCUSED_BORDER =>
      OutlineInputBorder(borderSide: BorderSide(width: 2.0, color: Theme.of(_context).colorScheme.onBackground));
  InputBorder get ERROR_BORDER => OutlineInputBorder(borderSide: BorderSide(color: Colors.red.shade400, width: 2.0));
  InputBorder get ENABLED_BORDER =>
      OutlineInputBorder(borderSide: BorderSide(width: 2.0, color: Theme.of(_context).colorScheme.onBackground));

  InputTheme(BuildContext context) {
    _context = context;
  }
}
