import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jellyflut/theme.dart';

MaterialStateProperty<Color> cancelButtonForeground() {
  return MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    return Colors.red;
  });
}

MaterialStateProperty<Color> cancelButtonBackground() {
  return MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered) ||
        states.contains(MaterialState.pressed) ||
        states.contains(MaterialState.selected) ||
        states.contains(MaterialState.dragged)) {
      return Colors.red.withOpacity(0.1);
    }
    return Colors.transparent;
  });
}

MaterialStateProperty<Color> submitButtonForeground() {
  return MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    return Colors.white;
  });
}

MaterialStateProperty<Color> submitButtonBackground() {
  return MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
    return jellyPurple;
  });
}
