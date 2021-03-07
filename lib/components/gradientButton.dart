import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/item.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
                shape: StadiumBorder(),
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                textStyle: TextStyle(color: Colors.black))
            .copyWith(side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered) ||
                states.contains(MaterialState.focused)) {
              return BorderSide(
                width: 2,
                color: Colors.white,
              );
            }
            return null; // defer to the default
          },
        )).copyWith(elevation: MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered) ||
                states.contains(MaterialState.focused)) {
              return 6;
            }
            return null; // defer to the default
          },
        )),
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
