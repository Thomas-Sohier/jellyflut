import 'package:flutter/widgets.dart';
import 'package:jellyflut/theme.dart';

class GradientMask extends StatelessWidget {
  final double radius;
  final Widget child;

  const GradientMask({Key? key, required this.child, this.radius = 0.5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: radius,
          colors: <Color>[jellyLightBLue, jellyLightPurple],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
