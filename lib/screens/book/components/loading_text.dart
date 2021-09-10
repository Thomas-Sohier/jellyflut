import 'package:flutter/material.dart';

class LoadingText extends StatelessWidget {
  static final List<Shadow> shadows = <Shadow>[
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 3.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    Shadow(
      offset: Offset(4.0, 4.0),
      blurRadius: 10.0,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    Shadow(
        offset: Offset(-1.0, -1.0),
        blurRadius: 8.0,
        color: Color.fromARGB(125, 0, 0, 255)),
    Shadow(
      offset: Offset(-4.0, -4.0),
      blurRadius: 10.0,
      color: Color.fromARGB(255, 0, 0, 0),
    )
  ];
  const LoadingText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Loading...',
        textAlign: TextAlign.center,
        style:
            Theme.of(context).textTheme.headline1!.copyWith(shadows: shadows));
  }
}
