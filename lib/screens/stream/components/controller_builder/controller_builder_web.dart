import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/stream/exception/unsupported_player_exception.dart';
import 'package:video_player/video_player.dart';

import '../../cubit/stream_cubit.dart';

/// Automatically create widget depending of controller provided
/// Can throw [UnsupportedPlayerException] if controller is not recognized
class Controllerbuilder extends StatelessWidget {
  const Controllerbuilder({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<StreamCubit>().state.controller is VideoPlayerController) {
      return VideoPlayer(context.read<StreamCubit>().state.controller as VideoPlayerController, key: UniqueKey());
    } else {
      throw UnsupportedPlayerException('Unknow controller');
    }
  }
}
