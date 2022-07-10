import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/globals.dart';

import '../bloc/music_player_bloc.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = context.read<MusicPlayerBloc>();
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [],
            borderRadius: borderRadiusButton,
          ),
          child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
            buildWhen: (previous, current) => previous.playingState != current.playingState,
            builder: (context, state) => OutlinedButtonSelector(
                onPressed: () => musicPlayerBloc.add(TogglePlayPauseRequested()),
                shape: const RoundedRectangleBorder(
                  borderRadius: borderRadiusButton,
                ),
                child: Icon(
                  state.playingState == PlayingState.pause ? Icons.pause : Icons.play_arrow,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 42,
                )),
          )),
    );
  }
}
