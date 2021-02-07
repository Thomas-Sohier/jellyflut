import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/callOnceClick.dart';

class GradienButton extends StatefulWidget {
  GradienButton(this.text, this.onPressed,
      {this.borderRadius = 25.0,
      this.child,
      this.item,
      this.icon,
      this.color1 = const Color(0xFFa95dc3),
      this.color2 = const Color(0xFF04a2db)});

  final Widget child;
  final Item item;
  final VoidCallback onPressed;
  final String text;
  final double borderRadius;
  final Color color1;
  final Color color2;
  final IconData icon;

  @override
  State<StatefulWidget> createState() => _GradienButtonState();
}

class _GradienButtonState extends State<GradienButton> {
  CallOnce _callOnce;

  @override
  void initState() {
    super.initState();

    _callOnce = CallOnce(widget.onPressed);
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: _callOnce.invoke,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side: BorderSide(color: Colors.transparent)),
        textColor: Colors.black,
        color: Colors.transparent,
        child: customPalette(
            widget.color1, widget.color2, widget.text, widget.icon));
  }
}

Widget customPalette(
    Color jellyPurple, Color color2, String text, IconData icon) {
  return Ink(
    key: ValueKey<int>(1),
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [jellyPurple, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
      borderRadius: BorderRadius.all(Radius.circular(80.0)),
    ),
    child: Container(
        height: 50,
        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
        alignment: Alignment.center,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              if (icon != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                )
            ])),
  );
}
