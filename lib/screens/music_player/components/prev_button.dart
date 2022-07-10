import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

import '../bloc/music_player_bloc.dart';

class PrevButton extends StatelessWidget {
  static const List<BoxShadow> shadows = [BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: 2)];

  const PrevButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => context.read<MusicPlayerBloc>().add(PreviousSongRequested()),
        shape: const RoundedRectangleBorder(
          borderRadius: borderRadiusButton,
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary, boxShadow: shadows, borderRadius: borderRadiusButton),
          child: Icon(
            Icons.skip_previous,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 32,
          ),
        ));
  }
}
