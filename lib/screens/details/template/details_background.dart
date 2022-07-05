import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';

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
    return BlocBuilder<DetailsBloc, DetailsState>(
        builder: (context, state) => AnimatedContainer(
            duration: duration,
            decoration: BoxDecoration(
                color: Colors.transparent.withOpacity(0.6),
                gradient: LinearGradient(
                  colors: [
                    state.theme.colorScheme.primary,
                    state.theme.colorScheme.secondary,
                    state.theme.colorScheme.tertiary
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ))));
  }
}
