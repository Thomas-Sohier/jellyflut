import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';

class DetailsBackground extends StatelessWidget {
  const DetailsBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Color>>(
        stream: BlocProvider.of<DetailsBloc>(context).gradientStream,
        builder: (context, snapshot) {
          final gradient = snapshot.data ?? <Color>[];
          return AnimatedContainer(
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.55),
                gradient: gradient.isNotEmpty
                    ? LinearGradient(
                        colors: gradient,
                        // stops: [0, 0.01, 0.02, 1],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null),
          );
        });
  }
}
