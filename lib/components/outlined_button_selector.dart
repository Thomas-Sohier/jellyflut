import 'package:flutter/material.dart';
import 'package:jellyflut/mixins/absorb_action.dart';

class OutlinedButtonSelector extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final OutlinedBorder shape;
  final Alignment? alignment;
  final EdgeInsets padding;
  final Color? primary;
  final Color background;

  const OutlinedButtonSelector(
      {super.key,
      required this.child,
      required this.onPressed,
      this.padding = EdgeInsets.zero,
      this.alignment,
      this.primary,
      this.background = Colors.transparent,
      this.shape = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      )});

  @override
  State<OutlinedButtonSelector> createState() => _OutlinedButtonSelectorState();
}

class _OutlinedButtonSelectorState extends State<OutlinedButtonSelector> with AbsordAction {
  Widget get child => widget.child;
  VoidCallback get onPressed => widget.onPressed;
  OutlinedBorder get shape => widget.shape;
  Alignment? get alignment => widget.alignment;
  EdgeInsets get padding => widget.padding;
  Color? get primary => widget.primary;
  Color get background => widget.background;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        autofocus: false,
        onPressed: () => action(onPressed),
        style: OutlinedButton.styleFrom(
                minimumSize: Size(24, 24),
                foregroundColor: primary ?? Theme.of(context).colorScheme.onBackground.withOpacity(0.05),
                alignment: alignment,
                padding: padding,
                shape: shape)
            .copyWith(side: _buttonBorderSide(context)),
        child: child);
  }

  MaterialStateProperty<BorderSide> _buttonBorderSide(BuildContext context) {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: primary ?? Theme.of(context).colorScheme.onBackground,
          );
        }
        return BorderSide(width: 0, color: Colors.transparent); // defer to the default
      },
    );
  }
}
