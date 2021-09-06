import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jellyflut/screens/details/shared/luminance.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;

class RightDetailsBackground extends StatelessWidget {
  final Future<Color> dominantColorFuture;
  final Widget child;
  const RightDetailsBackground(
      {Key? key, required this.dominantColorFuture, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
            child: FutureBuilder<Color>(
                future: dominantColorFuture,
                builder: (context, colorsSnapshot) {
                  if (colorsSnapshot.hasData) {
                    final finalDetailsThemeData =
                        Luminance.computeLuminance(colorsSnapshot.data!);
                    return background(finalDetailsThemeData, context);
                  }
                  return background(
                      personnal_theme.Theme.defaultThemeData, context);
                })));
  }

  Widget background(ThemeData theme, BuildContext context) {
    return Theme(
      data: theme,
      child: Container(
        decoration:
            BoxDecoration(color: theme.backgroundColor.withOpacity(0.4)),
        child: child,
      ),
    );
  }
}
