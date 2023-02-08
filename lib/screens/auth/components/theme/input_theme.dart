import 'package:flutter/material.dart';

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
      if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
        return 6;
      }
      return 0; // defer to the default
    },
  );
}

MaterialStateProperty<BorderSide> buttonBorderSide(BuildContext context) {
  return MaterialStateProperty.resolveWith<BorderSide>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
        return BorderSide(width: 2, color: Theme.of(context).colorScheme.onBackground);
      }
      return BorderSide(width: 0, color: Colors.transparent); // defer to the default
    },
  );
}

MaterialStateProperty<OutlinedBorder> buttonShape() {
  return MaterialStateProperty.resolveWith<OutlinedBorder>((Set<MaterialState> states) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
  });
}
