import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF3E2247), Color(0xFF003C50)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: child,
    );
  }
}
