import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/details_background.dart';

class DetailsBackgroundBuilder extends StatelessWidget {
  const DetailsBackgroundBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
            child: listenBlocDetails(context)));
  }

  Widget listenBlocDetails(BuildContext context) {
    return StreamBuilder<Future<List<Color>>>(
        stream:
            BlocProvider.of<DetailsBloc>(context).detailsInfos.dominantColor,
        builder: (context, snapshot) {
          if (snapshot.hasData) buildBackgroundFromFuture(snapshot.data);
          return DetailsBackground(colors: []);
        });
  }

  Widget buildBackgroundFromFuture(Future<List<Color>>? colors) {
    return FutureBuilder<List<Color>>(
        future: colors,
        builder: (context, colorsSnapshot) {
          if (colorsSnapshot.hasData && colorsSnapshot.data!.isNotEmpty) {
            return DetailsBackground(colors: colorsSnapshot.data);
          }
          return DetailsBackground(colors: []);
        });
  }
}
