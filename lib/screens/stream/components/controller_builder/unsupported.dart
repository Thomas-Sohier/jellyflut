import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/screens/stream/exception/unsupported_player_exception.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';

/// Automatically create widget depending of controller provided
/// Can throw [UnsupportedPlayerException] if controller is not recognized

class Controllerbuilder extends StatelessWidget {
  const Controllerbuilder({super.key});

  @override
  Widget build(BuildContext context) {
    SnackbarUtil.message(messageTitle: 'Unsupported platform', icon: Icons.error, color: Colors.red, context: context);
    context.router.root.pop();
    return const SizedBox();
  }
}
