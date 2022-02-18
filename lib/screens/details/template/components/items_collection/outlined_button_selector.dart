import 'package:flutter/material.dart';

class OutlinedButtonSelector extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final OutlinedBorder shape;
  final EdgeInsets padding;

  const OutlinedButtonSelector(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.padding = EdgeInsets.zero,
      this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      )})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        autofocus: false,
        onPressed: onPressed,
        style: TextButton.styleFrom(
                minimumSize: Size(24, 24),
                padding: padding,
                shape: shape,
                backgroundColor: Colors.transparent)
            .copyWith(side: buttonBorderSide(context))
            // .copyWith(elevation: buttonElevation())
            .copyWith(backgroundColor: buttonColor(context)),
        child: child);
  }

  MaterialStateProperty<BorderSide> buttonBorderSide(BuildContext context) {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.onBackground,
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

  MaterialStateProperty<Color> buttonColor(BuildContext context) {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return Theme.of(context).colorScheme.onBackground.withOpacity(0.05);
        }
        return Colors.transparent; // defer to the default
      },
    );
  }
}
