import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class PaletteButton extends StatefulWidget {
  PaletteButton(
    this.text, {
    required this.onPressed,
    this.dominantColorFuture,
    this.borderRadius = 80.0,
    this.minWidth = 88.0,
    this.maxWidth = 200.0,
    this.item,
    this.icon,
  });

  final Item? item;
  final VoidCallback onPressed;
  final String text;
  final double borderRadius;
  final double minWidth;
  final double maxWidth;
  final Icon? icon;
  final Future<Color>? dominantColorFuture;

  @override
  State<StatefulWidget> createState() => _PaletteButtonState();
}

class _PaletteButtonState extends State<PaletteButton>
    with AutomaticKeepAliveClientMixin {
  // variable for both button
  // size
  double minWidth = 88.0;
  double minHeight = 36.0;
  double maxWidth = 200;
  double maxHeight = 50;
  // padding of icon if one
  final EdgeInsets padding = EdgeInsets.fromLTRB(5, 0, 5, 0);

  late FocusNode _node;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _node = FocusNode(descendantsAreFocusable: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    minWidth = widget.minWidth;
    maxWidth = widget.maxWidth;
    super.build(context);
    var borderRadius = BorderRadius.all(Radius.circular(widget.borderRadius));
    return TextButton(
        autofocus: false,
        focusNode: _node,
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius, // <-- Radius
                ),
                backgroundColor: Colors.transparent,
                textStyle: TextStyle(color: Colors.black))
            .copyWith(side: buttonBorderSide())
            .copyWith(elevation: buttonElevation()),
        child: widget.dominantColorFuture == null
            ? buttonDefault(borderRadius)
            : generatedPalette(borderRadius));
  }

  Widget generatedPalette(BorderRadius borderRadius) {
    return FutureBuilder<Color>(
      future: widget.dominantColorFuture,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          final paletteColor =
              ColorUtil.changeColorSaturation(snapshot.data!, 0.5);
          final leftColor = ColorUtil.lighten(paletteColor, 0.2);
          final rightColor = ColorUtil.darken(paletteColor, 0.2);
          final colorInMiddle =
              Color.lerp(leftColor, rightColor, 0.5) ?? paletteColor;
          final foregroundColor = colorInMiddle.computeLuminance() > 0.45
              ? Colors.black
              : Colors.white;
          child = Ink(
            key: ValueKey<int>(0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [leftColor, colorInMiddle, rightColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: borderRadius),
            child: Container(
              constraints: BoxConstraints(
                  minHeight: minHeight,
                  minWidth: minWidth,
                  maxWidth: maxWidth,
                  maxHeight: maxHeight),
              alignment: Alignment.center,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: foregroundColor, fontSize: 18),
                    ),
                    if (widget.icon != null)
                      Padding(
                        padding: padding,
                        child: Icon(
                          widget.icon!.icon,
                          color: foregroundColor,
                        ),
                      )
                  ]),
            ),
          );
        } else if (snapshot.hasError) {
          return buttonDefault(borderRadius);
        } else {
          child = buttonDefault(borderRadius);
        }
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            switchInCurve: Curves.easeInOutBack,
            child: child);
      },
    );
  }

  Widget buttonDefault(BorderRadius borderRadius) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
            constraints: BoxConstraints(
                minHeight: minHeight,
                minWidth: minWidth,
                maxWidth: maxWidth,
                maxHeight: maxHeight),
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
                    widget.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  if (widget.icon != null)
                    Padding(
                      padding: padding,
                      child: widget.icon,
                    )
                ])),
      ),
    );
  }

  MaterialStateProperty<double> buttonElevation() {
    return MaterialStateProperty.resolveWith<double>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return 6;
        }
        return 0; // defer to the default
      },
    );
  }

  MaterialStateProperty<BorderSide> buttonBorderSide() {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: Colors.white,
          );
        }
        return BorderSide(
            width: 0, color: Colors.transparent); // defer to the default
      },
    );
  }
}
