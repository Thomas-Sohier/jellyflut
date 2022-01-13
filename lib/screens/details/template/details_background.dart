import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/shared/luminance.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class DetailsBackground extends StatefulWidget {
  final List<Color>? colors;
  DetailsBackground({Key? key, this.colors}) : super(key: key);

  @override
  _DetailsBackgroundState createState() => _DetailsBackgroundState();
}

class _DetailsBackgroundState extends State<DetailsBackground> {
  final List<Color> gradient = [];
  late final DetailsBloc bloc;
  late final StreamSubscription<List<Color>> sub;
  late Color paletteColor1;
  late Color paletteColor2;
  late Color leftColor;
  late Color rightColor;
  late ThemeData theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);

    // listening to stream and then update colors is way more performant than
    //doing this in the build method as before
    bloc = BlocProvider.of<DetailsBloc>(context);
    sub = bloc.gradientStream.stream.listen((event) {});
    sub.onData(updateColor);
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  void updateColor(List<Color> colors) {
    if (colors.isNotEmpty) {
      setState(() {
        paletteColor1 =
            ColorUtil.changeColorSaturation(colors[1], 0.5).withOpacity(0.55);
        paletteColor2 =
            ColorUtil.changeColorSaturation(colors[2], 0.5).withOpacity(0.55);
        gradient.clear();
        gradient.addAll([paletteColor1, paletteColor2]);
        final middleColor =
            Color.lerp(paletteColor1, paletteColor2, 0.5) ?? rightColor;
        theme = Luminance.computeLuminance(middleColor);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
            color: theme.backgroundColor.withOpacity(0.55),
            gradient:
                gradient.isNotEmpty ? LinearGradient(colors: gradient) : null),
      ),
    );
  }
}
