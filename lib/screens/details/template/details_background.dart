import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/shared/luminance.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;

class DetailsBackground extends StatelessWidget {
  final Widget child;
  const DetailsBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
            child: StreamBuilder<Future<List<Color>>>(
                stream: BlocProvider.of<DetailsBloc>(context)
                    .detailsInfos
                    .dominantColor,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return FutureBuilder<List<Color>>(
                        future: snapshot.data,
                        builder: (context, colorsSnapshot) {
                          if (colorsSnapshot.hasData &&
                              colorsSnapshot.data!.isNotEmpty) {
                            final paletteColor1 =
                                ColorUtil.changeColorSaturation(
                                        colorsSnapshot.data![1], 0.5)
                                    .withOpacity(0.55);
                            final paletteColor2 =
                                ColorUtil.changeColorSaturation(
                                        colorsSnapshot.data![2], 0.5)
                                    .withOpacity(0.55);
                            final leftColor =
                                ColorUtil.lighten(paletteColor1, 0.1);
                            final rightColor =
                                ColorUtil.darken(paletteColor2, 0.1);
                            return background(
                                personnal_theme.Theme.defaultThemeData,
                                context,
                                [leftColor, rightColor]);
                          }
                          return background(
                              personnal_theme.Theme.defaultThemeData,
                              context, []);
                        });
                  }
                  return background(
                      personnal_theme.Theme.defaultThemeData, context, []);
                })));
  }

  Widget background(ThemeData theme, BuildContext context, List<Color> colors) {
    // useful to have the best contrast
    final backgroundColor = theme.backgroundColor.computeLuminance() > 0.5
        ? ColorUtil.lighten(theme.backgroundColor, 0.3)
        : ColorUtil.darken(theme.backgroundColor, 0.3);

    return Theme(
      data: theme,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
            // color: backgroundColor.withOpacity(0.55),
            gradient:
                colors.isNotEmpty ? LinearGradient(colors: colors) : null),
        child: child,
      ),
    );
  }
}
