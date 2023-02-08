import 'package:flutter/material.dart';
import 'package:jellyflut/mixins/absorb_action.dart';

class GradienButton extends StatefulWidget {
  GradienButton(this.text, this.onPressed,
      {this.borderRadius = 25.0,
      this.child,
      this.enabled = true,
      this.icon,
      this.foregroundColor = const Color(0xFFFFFFFF),
      this.color1 = const Color(0xFFa95dc3),
      this.color2 = const Color(0xFF04a2db)});

  final Widget? child;
  final bool enabled;
  final VoidCallback onPressed;
  final String text;
  final double borderRadius;
  final Color foregroundColor;
  final Color color1;
  final Color color2;
  final IconData? icon;

  @override
  State<StatefulWidget> createState() => _GradienButtonState();
}

class _GradienButtonState extends State<GradienButton> with AbsordAction {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => widget.enabled ? action(widget.onPressed) : null,
        style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius))),
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                elevation: 0,
                side: BorderSide.none)
            .copyWith(side: buttonBorderSide())
            .copyWith(elevation: butonElevation()),
        child: customPalette());
  }

  Widget customPalette() {
    return Ink(
      key: ValueKey<int>(1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [widget.color1, widget.color2], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
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
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: widget.foregroundColor, fontSize: 18),
                ),
                if (widget.child != null) widget.child!,
                if (widget.icon != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Icon(
                      widget.icon,
                      color: widget.foregroundColor,
                    ),
                  )
              ])),
    );
  }

  MaterialStateProperty<BorderSide> buttonBorderSide() {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          if (!widget.enabled) {
            return BorderSide(width: 0, color: Colors.transparent);
          }

          return BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.onBackground,
          );
        }
        return BorderSide(width: 0, color: Colors.transparent);
      },
    );
  }

  MaterialStateProperty<double> butonElevation() {
    return MaterialStateProperty.resolveWith<double>(
      (Set<MaterialState> states) {
        if (!widget.enabled) return 0;
        if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          return 6;
        }
        return 0;
      },
    );
  }
}
