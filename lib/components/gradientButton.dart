import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/colors.dart';
import 'package:palette_generator/palette_generator.dart';

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
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: widget.onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side: BorderSide(color: Colors.transparent)),
        textColor: Colors.black,
        color: Colors.transparent,
        // child: customPalette(
        //     widget.color1, widget.color2, widget.text, widget.icon));
        child: widget.item == null
            ? customPalette(
                widget.color1, widget.color2, widget.text, widget.icon)
            : generatedPalette(widget.item, widget.text, widget.icon));
  }
}

Widget customPalette(Color color1, Color color2, String text, IconData icon) {
  return Ink(
    key: ValueKey<int>(1),
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [color1, color2],
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

Widget generatedPalette(Item item, String text, IconData icon) {
  return FutureBuilder<PaletteGenerator>(
    future: gePalette(getItemImageUrl(item.id, item.imageBlurHashes)),
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
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
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
      }
      return AnimatedSwitcher(
          duration: const Duration(milliseconds: 1500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(child: child, opacity: animation);
          },
          child: child);
    },
  );
}
