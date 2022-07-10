import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/screens/music_player/bloc/music_player_bloc.dart';
import 'package:jellyflut/shared/shared.dart';

class SongDurationPosition extends StatelessWidget {
  const SongDurationPosition({super.key});

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    return Row(
      children: [
        StreamBuilder<Duration?>(
            stream: musicPlayerBloc.state.postionStream,
            builder: (context, snapshot) => Text(
                  snapshot.data != null ? printDuration(snapshot.data!) : '0.00',
                  style: Theme.of(context).textTheme.bodyText1,
                )),
        Spacer(),
        StreamBuilder<Duration?>(
            stream: musicPlayerBloc.state.postionStream,
            builder: (context, snapshot) => Text(
                snapshot.data != null ? printDuration(musicPlayerBloc.state.duration) : '∞',
                style: Theme.of(context).textTheme.bodyText1))
      ],
    );
  }
}
