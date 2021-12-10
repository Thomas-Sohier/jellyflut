// mask layer

import 'package:flutter/painting.dart';
import 'package:jellyflut/theme.dart';

final Shader linearGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [jellyLightBLue, jellyLightPurple],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
