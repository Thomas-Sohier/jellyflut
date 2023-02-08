import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/music_player/bloc/music_player_bloc.dart';
import 'package:jellyflut/shared/shared.dart';

class SongDurationPosition extends StatelessWidget {
  const SongDurationPosition({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
            buildWhen: (previous, current) => previous.currentlyPlaying != current.currentlyPlaying,
            builder: (context, state) => StreamBuilder<Duration?>(
                stream: state.postionStream,
                builder: (context, snapshot) => Text(
                      snapshot.data != null ? printDuration(snapshot.data!) : '0.00',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ))),
        Spacer(),
        BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
            buildWhen: (previous, current) => previous.currentlyPlaying != current.currentlyPlaying,
            builder: (context, state) =>
                Text(printDuration(state.duration), style: Theme.of(context).textTheme.bodyLarge))
      ],
    );
  }
}
