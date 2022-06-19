import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class DetailsBackground extends StatelessWidget {
  const DetailsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = const Duration(milliseconds: 500);
    return StreamBuilder<ThemeData>(
        stream: BlocProvider.of<DetailsBloc>(context).themeStream,
        builder: (context, snapshot) {
          final colorScheme =
              snapshot.data?.colorScheme ?? Theme.of(context).colorScheme;
          return AnimatedContainer(
            duration: duration,
            decoration: BoxDecoration(
                color: Colors.transparent.withOpacity(0.5),
                gradient: LinearGradient(
                  colors: [
                    adjustColorToBrightness(
                        colorScheme.primary, colorScheme.brightness),
                    adjustColorToBrightness(
                        colorScheme.secondary, colorScheme.brightness),
                    adjustColorToBrightness(
                        colorScheme.tertiary, colorScheme.brightness)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )),
          );
        });
  }
}

Color adjustColorToBrightness(Color color, Brightness brightness) {
  if (brightness == Brightness.dark) {
    return ColorUtil.darken(color, 0.4);
  } else {
    return ColorUtil.lighten(color, 0.4);
  }
}
