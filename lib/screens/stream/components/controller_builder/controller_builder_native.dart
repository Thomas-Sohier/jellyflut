import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/stream/exception/unsupported_player_exception.dart';

import '../../cubit/stream_cubit.dart';

/// Automatically create widget depending of controller provided
/// Can throw [UnsupportedPlayerException] if controller is not recognized
class Controllerbuilder extends StatelessWidget {
  const Controllerbuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamCubit, StreamState>(
        buildWhen: (previous, current) =>
            (previous.controller != current.controller) && current.status == StreamStatus.success,
        builder: (_, state) {
          return state.controller?.createView() ?? const SizedBox();
        });
  }
}
