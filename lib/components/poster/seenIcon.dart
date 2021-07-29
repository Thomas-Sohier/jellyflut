import 'package:flutter/material.dart';

class SeenIcon extends StatelessWidget {
  const SeenIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(blurRadius: 0.0, color: Colors.white, spreadRadius: 0.0)
            ]),
        child: Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
        ));
  }
}
