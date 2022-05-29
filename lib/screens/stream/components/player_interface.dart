import 'package:flutter/material.dart';
import 'package:jellyflut/screens/stream/components/controller_builder.dart';

import 'common_controls.dart';

class PlayerInterface extends StatefulWidget {
  final dynamic controller;
  PlayerInterface({super.key, this.controller});

  @override
  _PlayerInterfaceState createState() => _PlayerInterfaceState();
}

class _PlayerInterfaceState extends State<PlayerInterface> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: <Widget>[
        Controllerbuilder(controller: widget.controller),
        CommonControls(),
      ],
    );
  }
}
