import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jellyflut/theme/theme_extend_own.dart';

class DetailsBackground extends StatelessWidget {
  const DetailsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0), child: GradientBuilder()));
  }
}

class GradientBuilder extends StatelessWidget {
  static const duration = Duration(milliseconds: 500);
  const GradientBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: duration,
        decoration: BoxDecoration(
            color: Colors.transparent.withOpacity(0.6),
            gradient: LinearGradient(
              colors: [
                ownDetailsTheme(context).primary,
                ownDetailsTheme(context).secondary,
                ownDetailsTheme(context).tertiary
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )));
  }
}
