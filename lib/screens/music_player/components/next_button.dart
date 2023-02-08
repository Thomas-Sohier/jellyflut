import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/music_player/bloc/music_player_bloc.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => context.read<MusicPlayerBloc>().add(NextSongRequested()),
        background: Theme.of(context).colorScheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: borderRadiusButton,
        ),
        child: IgnorePointer(
          child: IconButton(
            iconSize: 32,
            icon: Icon(
              Icons.skip_next,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {},
          ),
        ));
  }
}
