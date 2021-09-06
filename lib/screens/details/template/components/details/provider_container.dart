import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/shared/colors.dart';

class ProviderContainer extends StatelessWidget {
  final String value;
  const ProviderContainer({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => {},
      style: TextButton.styleFrom(
              padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
              alignment: Alignment.center,
              side: BorderSide(
                  width: 1,
                  style: BorderStyle.solid,
                  color: Theme.of(context).primaryColor))
          .copyWith(backgroundColor: buttonBackground(context))
          .copyWith(foregroundColor: buttonForeground(context))
          .copyWith(overlayColor: buttonBackground(context)),
      child: Text(
        value,
        style: TextStyle(fontFamily: 'Quicksand'),
      ),
    );
  }

  MaterialStateProperty<Color> buttonBackground(BuildContext context) {
    return MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered) ||
          states.contains(MaterialState.focused)) {
        return Theme.of(context).primaryColor;
      }
      return Colors.transparent;
    });
  }

  MaterialStateProperty<Color> buttonForeground(BuildContext context) {
    return MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.hovered) ||
          states.contains(MaterialState.focused)) {
        return ColorUtil.invert(Theme.of(context).primaryColor);
      }
      return Theme.of(context).primaryColor;
    });
  }
}
