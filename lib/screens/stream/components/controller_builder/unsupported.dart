import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/stream/exception/unsupported_player_exception.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';

/// Automatically create widget depending of controller provided
/// Can throw [UnsupportedPlayerException] if controller is not recognized
class Controllerbuilder extends StatefulWidget {
  final dynamic controller;
  Controllerbuilder({super.key, required this.controller});

  @override
  State<Controllerbuilder> createState() => _ControllerbuilderState();
}

class _ControllerbuilderState extends State<Controllerbuilder> {
  @override
  void initState() {
    super.initState();
    SnackbarUtil.message('Unsupported platform', Icons.error, Colors.red);
    customRouter.pop();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
