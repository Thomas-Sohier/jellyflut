import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/globals.dart';

import '../bloc/music_player_bloc.dart';

class PlayPauseButton extends StatelessWidget {
  static const List<BoxShadow> shadows = [BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: 2)];

  const PlayPauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => context.read<MusicPlayerBloc>().add(TogglePlayPauseRequested()),
        background: Theme.of(context).colorScheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: borderRadiusButton,
        ),
        child: SizedBox(
          height: 68,
          width: 68,
          child: IgnorePointer(
            child: IconButton(
              iconSize: 42,
              icon: getIcon(),
              onPressed: () {},
            ),
          ),
        ));
  }

  Widget getIcon() {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        buildWhen: (previous, current) => previous.playingState != current.playingState,
        builder: (context, state) => Icon(
              state.playingState == PlayingState.pause ? Icons.play_arrow : Icons.pause,
              color: Theme.of(context).colorScheme.onPrimary,
            ));
  }
}
