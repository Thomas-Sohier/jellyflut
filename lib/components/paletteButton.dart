import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/colors.dart';
import 'package:palette_generator/palette_generator.dart';

class PaletteButton extends StatefulWidget {
  PaletteButton(
    this.text,
    this.onPressed, {
    this.borderRadius = 80.0,
    this.child,
    this.item,
    this.icon,
  });

  final Widget child;
  final Item item;
  final VoidCallback onPressed;
  final String text;
  final double borderRadius;
  final IconData icon;

  @override
  State<StatefulWidget> createState() => _PaletteButtonState();
}

class _PaletteButtonState extends State<PaletteButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.all(Radius.circular(widget.borderRadius));
    return Container(
        constraints: const BoxConstraints(
            minWidth: 88.0, minHeight: 36.0, maxWidth: 200, maxHeight: 50),
        child: FlatButton(
            padding: EdgeInsets.zero,
            onPressed: widget.onPressed,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: BorderSide(color: Colors.transparent)),
            textColor: Colors.black,
            color: Colors.transparent,
            child: widget.item == null
                ? buttonDefault(widget.text, widget.icon, borderRadius)
                : generatedPalette(
                    widget.item, widget.text, widget.icon, borderRadius)));
  }
}

Widget generatedPalette(
    Item item, String text, IconData icon, BorderRadius borderRadius) {
  return FutureBuilder<PaletteGenerator>(
    future: gePalette(getItemImageUrl(
        item.correctImageId(), item.correctImageTags(),
        imageBlurHashes: item.imageBlurHashes)),
    builder: (context, snapshot) {
      Widget child;
      if (snapshot.hasData) {
        var paletteColor = snapshot.data.paletteColors;
        var foregroundColor = paletteColor[0].color.computeLuminance() > 0.5
            ? Colors.black
            : Colors.white;
        child = Ink(
          key: ValueKey<int>(0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [paletteColor[0].color, paletteColor[1].color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: borderRadius),
          child: Container(
              constraints: const BoxConstraints(
                  minWidth: 88.0,
                  minHeight: 36.0,
                  maxWidth: 200,
                  maxHeight: 50),
              alignment: Alignment.center,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: foregroundColor, fontSize: 18),
                    ),
                    if (icon != null)
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Icon(
                          icon,
                          color: foregroundColor,
                        ),
                      )
                  ])),
        );
      } else if (snapshot.hasError) {
        return buttonDefault(text, icon, borderRadius);
      } else {
        child = buttonDefault(text, icon, borderRadius);
      }
      return AnimatedSwitcher(
          duration: const Duration(milliseconds: 1500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(child: child, opacity: animation);
          },
          switchInCurve: Curves.easeInToLinear,
          child: child);
    },
  );
}

Widget buttonDefault(String text, IconData icon, BorderRadius borderRadius) {
  return ClipRRect(
    borderRadius: borderRadius,
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
          constraints: const BoxConstraints(
              minWidth: 88.0, minHeight: 36.0, maxWidth: 200, maxHeight: 50),
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withOpacity(0.5),
            borderRadius: borderRadius,
          ),
          alignment: Alignment.center,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Icon(
                      icon,
                      color: Colors.black,
                    ),
                  )
              ])),
    ),
  );
}
