import 'package:flutter/material.dart';

class GradientMask extends StatelessWidget {
  final double radius;
  final Widget child;

  const GradientMask({super.key, required this.child, this.radius = 0.5});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: radius,
          colors: <Color>[Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
