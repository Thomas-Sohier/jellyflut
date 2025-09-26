import 'package:flutter/material.dart';

// Back button
WidgetStateProperty<EdgeInsetsGeometry> buttonPadding() {
  return WidgetStateProperty.resolveWith<EdgeInsetsGeometry>((Set<WidgetState> states) {
    return EdgeInsets.zero;
  });
}

WidgetStateProperty<double> buttonElevation() {
  return WidgetStateProperty.resolveWith<double>((Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
      return 6;
    }
    return 0; // defer to the default
  });
}

WidgetStateProperty<BorderSide> buttonBorderSide(BuildContext context) {
  return WidgetStateProperty.resolveWith<BorderSide>((Set<WidgetState> states) {
    if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)) {
      return BorderSide(width: 2, color: Theme.of(context).colorScheme.onSurface);
    }
    return BorderSide(width: 0, color: Colors.transparent); // defer to the default
  });
}

WidgetStateProperty<OutlinedBorder> buttonShape() {
  return WidgetStateProperty.resolveWith<OutlinedBorder>((Set<WidgetState> states) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
  });
}
