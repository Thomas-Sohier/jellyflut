import 'package:flutter/material.dart';

import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

class SettingsButton extends StatefulWidget {
  @override
  _SettingsButtonState createState() => _SettingsButtonState();
}

class _SettingsButtonState extends State<SettingsButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        shape: CircleBorder(),
        padding: EdgeInsets.all(8),
        onPressed: () => customRouter.push(SettingsRoute()),
        child: Icon(
          Icons.settings,
          size: 26,
          color: Theme.of(context).colorScheme.onBackground,
        ));
  }
}
