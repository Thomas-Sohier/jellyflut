import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

import '../bloc/music_player_bloc.dart';

class PrevButton extends StatelessWidget {
  const PrevButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => context.read<MusicPlayerBloc>().add(PreviousSongRequested()),
        background: Theme.of(context).colorScheme.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: borderRadiusButton,
        ),
        child: IgnorePointer(
          child: IconButton(
            iconSize: 32,
            icon: Icon(
              Icons.skip_previous,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {},
          ),
        ));
  }
}
