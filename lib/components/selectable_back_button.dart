import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class SelectableBackButton extends StatelessWidget {
  const SelectableBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        autofocus: false,
        onPressed: context.router.root.pop,
        style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onBackground,
                minimumSize: Size(24, 24),
                padding: EdgeInsets.all(12),
                shape: const CircleBorder())
            .copyWith(side: _buttonBorderSide(context)),
        child: Icon(Icons.arrow_back));
  }

  MaterialStateProperty<BorderSide> _buttonBorderSide(BuildContext context) {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
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
