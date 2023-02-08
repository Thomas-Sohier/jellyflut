import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut/components/outlined_button_selector.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        shape: CircleBorder(),
        padding: EdgeInsets.all(8),
        onPressed: () => context.router.root.push(r.SettingsPage()),
        child: Icon(
          Icons.settings,
          size: 26,
          color: Theme.of(context).colorScheme.onBackground,
        ));
  }
}
