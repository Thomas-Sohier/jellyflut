// mask layer
import 'package:flutter/widgets.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:jellyflut/shared/theme.dart';

final Shader linearGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [jellyLightBLue, jellyLightPurple],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
