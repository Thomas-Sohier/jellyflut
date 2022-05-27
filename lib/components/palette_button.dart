import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jellyflut/mixins/absorb_action.dart';

import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class PaletteButton extends StatefulWidget {
  PaletteButton(
    this.text, {
    required this.onPressed,
    this.dominantColorFuture,
    this.enabled = true,
    this.borderRadius = 80.0,
    this.minHeight = 40.0,
    this.maxHeight = double.infinity,
    this.minWidth = 88.0,
    this.maxWidth = 200.0,
    this.item,
    this.trailing,
    this.icon,
  });

  final Item? item;
  final VoidCallback onPressed;
  final String text;
  final bool enabled;
  final double borderRadius;
  final double minHeight;
  final double maxHeight;
  final double minWidth;
  final double maxWidth;
  final Icon? icon;
  final Widget? trailing;
  final Future<List<Color>>? dominantColorFuture;

  @override
  State<StatefulWidget> createState() => _PaletteButtonState();
}

class _PaletteButtonState extends State<PaletteButton>
    with AutomaticKeepAliveClientMixin, AbsordAction {
  // variable for both button
  // size
  late double minWidth;
  late double minHeight;
  late double maxWidth;
  late double maxHeight;
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
    super.build(context);
    minWidth = widget.minWidth;
    minHeight = widget.minHeight;
    maxWidth = widget.maxWidth;
    maxHeight = widget.maxHeight;

    var borderRadius = BorderRadius.all(Radius.circular(widget.borderRadius));
    return ConstrainedBox(
      constraints: BoxConstraints(
          minHeight: minHeight,
          minWidth: minWidth,
          maxWidth: maxWidth,
          maxHeight: maxHeight),
      child: IgnorePointer(
        ignoring: !widget.enabled,
        child: Center(
          child: TextButton(
              autofocus: false,
              focusNode: _node,
              onPressed: () => action(widget.onPressed),
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
                  : generatedPalette(borderRadius)),
        ),
      ),
    );
  }

  Widget generatedPalette(BorderRadius borderRadius) {
    return FutureBuilder<List<Color>>(
      future: widget.dominantColorFuture,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final paletteColor1 =
              ColorUtil.changeColorSaturation(snapshot.data![1], 0.5)
                  .withOpacity(0.55);
          final paletteColor2 =
              ColorUtil.changeColorSaturation(snapshot.data![2], 0.5)
                  .withOpacity(0.55);
          final middleColor =
              Color.lerp(paletteColor1, paletteColor2, 0.5) ?? paletteColor2;

          final foregroundColor = middleColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white;
          child = Ink(
            key: ValueKey<int>(0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [paletteColor1, paletteColor2],
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
                      ),
                    if (widget.trailing != null) widget.trailing!
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
    final color = widget.enabled
        ? Colors.grey.shade200.withOpacity(0.5)
        : Colors.grey.shade400.withOpacity(0.5);
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
              color: color,
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
                    ),
                  if (widget.trailing != null) widget.trailing!
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
