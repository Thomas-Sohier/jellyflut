import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

import '../../cubit/stream_cubit.dart';

class PlayPauseButton extends StatelessWidget {
  final double? size;
  const PlayPauseButton({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StreamCubit, StreamState>(
      buildWhen: (previous, current) => previous.playing != current.playing,
      builder: (_, state) => OutlinedButtonSelector(
          onPressed: context.read<StreamCubit>().togglePlay,
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              state.playing ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: size,
            ),
          )),
    );
  }
}
