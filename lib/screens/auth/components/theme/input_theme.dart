import 'package:flutter/material.dart';

// Borders
final InputBorder DEFAULT_BORDER = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade700, width: 2.0));
final InputBorder FOCUSED_BORDER = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade900, width: 2.0));
final InputBorder ERROR_BORDER =
    OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0));
final InputBorder ENABLED_BORDER = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade800, width: 2.0));

// Input text
final TextStyle INPUT_TEXT_STYLE = TextStyle(color: Colors.black);

// Back button
MaterialStateProperty<EdgeInsetsGeometry> buttonPadding() {
  return MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
    (Set<MaterialState> states) {
      return EdgeInsets.zero;
    },
  );
}

MaterialStateProperty<double> buttonElevation() {
  return MaterialStateProperty.resolveWith<double>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered) ||
          states.contains(MaterialState.focused)) {
        return 6;
      }
      return 0; // defer to the default
    },
  );
}

MaterialStateProperty<BorderSide> buttonBorderSide() {
  return MaterialStateProperty.resolveWith<BorderSide>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered) ||
          states.contains(MaterialState.focused)) {
        return BorderSide(
          width: 2,
          color: Colors.grey.shade900,
        );
      }
      return BorderSide(
          width: 0, color: Colors.transparent); // defer to the default
    },
  );
}
