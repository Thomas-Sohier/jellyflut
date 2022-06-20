import 'package:flutter/material.dart';
import 'common_controls/common_controls.dart';
import 'controller_builder/controller_builder.dart';

class PlayerInterface extends StatefulWidget {
  final dynamic controller;
  PlayerInterface({super.key, this.controller});

  @override
  State<PlayerInterface> createState() => _PlayerInterfaceState();
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
