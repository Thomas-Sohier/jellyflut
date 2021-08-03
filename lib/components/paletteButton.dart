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

  final Widget? child;
  final Item? item;
  final VoidCallback onPressed;
  final String text;
  final double borderRadius;
  final IconData? icon;

  @override
  State<StatefulWidget> createState() => _PaletteButtonState();
}

class _PaletteButtonState extends State<PaletteButton>
    with AutomaticKeepAliveClientMixin {
  // variable for both button
  // size
  final double minWidth = 88.0;
  final double minHeight = 36.0;
  final double maxWidth = 200;
  final double maxHeight = 50;
  // padding of icon if one
  final EdgeInsets padding = EdgeInsets.fromLTRB(5, 0, 5, 0);

  late FocusNode _node;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _node = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var borderRadius = BorderRadius.all(Radius.circular(widget.borderRadius));
    return TextButton(
        autofocus: false,
        focusNode: _node,
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: StadiumBorder(),
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
            return BorderSide(
                width: 0, color: Colors.transparent); // defer to the default
          },
        )).copyWith(elevation: MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered) ||
                states.contains(MaterialState.focused)) {
              return 6;
            }
            return 0; // defer to the default
          },
        )),
        child: widget.item == null
            ? buttonDefault(borderRadius)
            : generatedPalette(borderRadius));
  }

  Widget generatedPalette(BorderRadius borderRadius) {
    return FutureBuilder<PaletteGenerator>(
      future: gePalette(getItemImageUrl(
          widget.item!.correctImageId(), widget.item!.correctImageTags(),
          imageBlurHashes: widget.item!.imageBlurHashes)),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          var paletteColor = snapshot.data!.paletteColors;
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
                constraints: BoxConstraints(
                    minWidth: minWidth,
                    minHeight: minHeight,
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
                            widget.icon,
                            color: foregroundColor,
                          ),
                        )
                    ])),
          );
        } else if (snapshot.hasError) {
          return buttonDefault(borderRadius);
        } else {
          child = buttonDefault(borderRadius);
        }
        return AnimatedSwitcher(
            duration: const Duration(milliseconds: 1500),
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
                minWidth: minWidth,
                minHeight: minHeight,
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
                      child: Icon(
                        widget.icon,
                        color: Colors.black,
                      ),
                    )
                ])),
      ),
    );
  }
}
