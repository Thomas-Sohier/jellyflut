import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jellyflut/screens/details/shared/luminance.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;

class RightDetailsBackground extends StatelessWidget {
  final Future<Color> dominantColorFuture;
  final Widget child;
  const RightDetailsBackground(
      {Key? key, required this.dominantColorFuture, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        clipBehavior: Clip.hardEdge,
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
    // useful to have the best contrast
    final backgroundColor = theme.backgroundColor.computeLuminance() > 0.5
        ? ColorUtil.lighten(theme.backgroundColor, 0.3)
        : ColorUtil.darken(theme.backgroundColor, 0.3);

    return Theme(
      data: theme,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(color: backgroundColor.withOpacity(0.55)),
        child: child,
      ),
    );
  }
}
