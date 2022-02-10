import 'package:flutter/material.dart';

class CustomGradient {
  late final BuildContext context;
  Shader get linearGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.tertiary
        ],
      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  CustomGradient(this.context);
}
