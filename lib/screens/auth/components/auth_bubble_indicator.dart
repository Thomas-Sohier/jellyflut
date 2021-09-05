import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/shared/theme.dart';

class AuthBubbleIndicator extends StatelessWidget {
  final String value;

  const AuthBubbleIndicator({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 300),
        height: 60,
        margin: EdgeInsets.only(left: 24, right: 24),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: jellyPurple,
            borderRadius: BorderRadius.all(Radius.circular(80.0))),
        child: Stack(alignment: Alignment.center, children: [
          Positioned.fill(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.dns,
                    color: Colors.white,
                  ))),
          Positioned.fill(
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )))
        ]));
  }
}
