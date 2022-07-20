import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jellyflut/mixins/absorb_action.dart';

class PaletteButton extends StatefulWidget {
  PaletteButton(
    this.text, {
    required this.onPressed,
    this.gradient = const <Color>[],
    this.useTheme = false,
    this.enabled = true,
    this.borderRadius = 80.0,
    this.minHeight = 40.0,
    this.maxHeight = double.infinity,
    this.minWidth = 88.0,
    this.maxWidth = 200.0,
    this.trailing,
    this.icon,
  });

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
  final bool useTheme;
  final List<Color> gradient;

  @override
  State<StatefulWidget> createState() => _PaletteButtonState();
}

class _PaletteButtonState extends State<PaletteButton> with AbsordAction {
  // variable for both button size
  double get minWidth => widget.minWidth;
  double get minHeight => widget.minHeight;
  double get maxWidth => widget.maxWidth;
  double get maxHeight => widget.maxHeight;

  // padding of icon if one
  final EdgeInsets padding = EdgeInsets.fromLTRB(5, 0, 5, 0);
  late FocusNode _node;
  late ThemeData _theme;

  List<Color> get gradient => widget.gradient;
  ThemeData get theme => _theme;
  bool get useTheme => widget.useTheme;
  BorderRadius get borderRadius => BorderRadius.all(Radius.circular(widget.borderRadius));

  @override
  void initState() {
    _node = FocusNode(descendantsAreFocusable: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    late final child;
    if (useTheme) {
      child = buttonFromTheme();
    } else if (gradient.isNotEmpty) {
      child = buttonFromColors();
    } else {
      child = buttonDefault();
    }

    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight, minWidth: minWidth, maxWidth: maxWidth, maxHeight: maxHeight),
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: Center(
            child: TextButton(
              autofocus: false,
              focusNode: _node,
              onPressed: () => action(widget.onPressed),
              style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: borderRadius),
                      backgroundColor: Colors.transparent,
                      textStyle: TextStyle(color: Colors.black))
                  .copyWith(side: buttonBorderSide())
                  .copyWith(elevation: buttonElevation()),
              child: child,
            ),
          ),
        ));
  }

  Widget buttonFromTheme() {
    final palette = [theme.colorScheme.primary, theme.colorScheme.secondary, theme.colorScheme.tertiary];
    final onBackground = theme.colorScheme.onBackground;
    return buttonFromPalette(palette, onBackground);
  }

  Widget buttonFromColors() {
    final middleElement = (gradient.length / 2).round() - 1;
    final onBackground = gradient[middleElement].computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return buttonFromPalette(gradient, onBackground);
  }

  Widget buttonFromPalette(List<Color> palette, Color onBackground) {
    return Ink(
      key: ValueKey<int>(0),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: palette,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: borderRadius),
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight, minWidth: minWidth, maxWidth: maxWidth, maxHeight: maxHeight),
        alignment: Alignment.center,
        child:
            Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(color: onBackground, fontSize: 18),
          ),
          if (widget.icon != null)
            Padding(
              padding: padding,
              child: Icon(
                widget.icon!.icon,
                color: onBackground,
              ),
            ),
          if (widget.trailing != null) widget.trailing!
        ]),
      ),
    );
  }

  Widget buttonDefault() {
    final color = widget.enabled ? Colors.grey.shade200.withOpacity(0.5) : Colors.grey.shade400.withOpacity(0.5);
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
            constraints:
                BoxConstraints(minHeight: minHeight, minWidth: minWidth, maxWidth: maxWidth, maxHeight: maxHeight),
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
        if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          return 6;
        }
        return 0; // defer to the default
      },
    );
  }

  MaterialStateProperty<BorderSide> buttonBorderSide() {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.onBackground,
          );
        }
        return BorderSide(width: 0, color: Colors.transparent); // defer to the default
      },
    );
  }
}
