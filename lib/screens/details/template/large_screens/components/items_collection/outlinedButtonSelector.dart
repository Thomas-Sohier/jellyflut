import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OutlinedButtonSelector extends StatelessWidget {
  final Widget child;
  final FocusNode node;
  final VoidCallback onPressed;
  final OutlinedBorder shape;

  const OutlinedButtonSelector(
      {Key? key,
      required this.child,
      required this.node,
      required this.onPressed,
      this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      )})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        autofocus: false,
        focusNode: node,
        onPressed: onPressed,
        style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: shape,
                backgroundColor: Colors.transparent)
            .copyWith(side: buttonBorderSide())
            // .copyWith(elevation: buttonElevation())
            .copyWith(backgroundColor: buttonColor()),
        child: child);
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

  MaterialStateProperty<Color> buttonColor() {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return Colors.white12;
        }
        return Colors.transparent; // defer to the default
      },
    );
  }
}
