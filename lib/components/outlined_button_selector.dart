import 'package:flutter/material.dart';

class OutlinedButtonSelector extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final OutlinedBorder shape;
  final Alignment? alignment;
  final EdgeInsets padding;
  final Color? primary;

  const OutlinedButtonSelector(
      {super.key,
      required this.child,
      required this.onPressed,
      this.padding = EdgeInsets.zero,
      this.alignment,
      this.primary,
      this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      )});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        autofocus: false,
        onPressed: onPressed,
        style: TextButton.styleFrom(
                minimumSize: Size(24, 24),
                primary: primary ??
                    Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.05),
                alignment: alignment,
                padding: padding,
                shape: shape,
                backgroundColor: Colors.transparent)
            .copyWith(side: buttonBorderSide(context)),
        child: child);
  }

  MaterialStateProperty<BorderSide> buttonBorderSide(BuildContext context) {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: primary ?? Theme.of(context).colorScheme.onBackground,
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
}
