import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/theme.dart';

final buttonColors = WindowButtonColors(
    iconNormal: Colors.white,
    mouseOver: Colors.grey.shade800,
    mouseDown: Colors.grey.shade800,
    iconMouseOver: jellyLightBLue[600],
    iconMouseDown: jellyPurpleMap[700]);

final closeButtonColors = WindowButtonColors(
    mouseOver: Color(0xFFD32F2F),
    mouseDown: Color(0xFFB71C1C),
    iconNormal: Colors.white,
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
