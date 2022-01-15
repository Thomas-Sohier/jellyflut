import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jellyflut/screens/details/template/details_background.dart';

class DetailsBackgroundBuilder extends StatelessWidget {
  final List<Color> colors;
  const DetailsBackgroundBuilder({Key? key, required this.colors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
            child: DetailsBackground(gradient: colors)));
  }
}
