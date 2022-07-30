import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/screens/stream/exception/unsupported_player_exception.dart';
import 'package:streaming_repository/streaming_repository.dart';
import 'package:video_player/video_player.dart';

import '../../cubit/stream_cubit.dart';

/// Automatically create widget depending of controller provided
/// Can throw [UnsupportedPlayerException] if controller is not recognized
class Controllerbuilder extends StatelessWidget {
  const Controllerbuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamCubit, StreamState>(
        buildWhen: (previous, current) => previous.controller != current.controller,
        builder: (_, state) {
          if (state.controller is CommonStreamBP) {
            return BetterPlayer(controller: state.controller?.controller);
          } else if (state.controller is CommonStreamVLC) {
            return VlcPlayer(
                controller: state.controller?.controller,
                aspectRatio: 16 / 9,
                placeholder: Center(child: CircularProgressIndicator()));
          } else if (state.controller is CommonStreamVLCComputer) {
            return Video(
              player: state.controller?.controller,
              showControls: false,
            );
          } else if (state.controller is CommonStreamVideoPlayer) {
            return VideoPlayer(state.controller?.controller);
          } else {
            throw UnsupportedPlayerException('Unknow controller');
          }
        });
  }
}
