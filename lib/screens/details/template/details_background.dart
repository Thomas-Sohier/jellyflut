import 'package:flutter/material.dart';

class DetailsBackground extends StatelessWidget {
  final List<Color> gradient;
  const DetailsBackground({Key? key, required this.gradient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor.withOpacity(0.55),
          gradient:
              gradient.isNotEmpty ? LinearGradient(colors: gradient) : null),
    );
  }
}
