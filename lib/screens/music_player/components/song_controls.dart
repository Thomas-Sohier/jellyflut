import 'package:flutter/material.dart';
import 'package:jellyflut/screens/music_player/components/next_button.dart';
import 'package:jellyflut/screens/music_player/components/play_pause_button.dart';
import 'package:jellyflut/screens/music_player/components/prev_button.dart';

class SongControls extends StatelessWidget {
  const SongControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [PrevButton(), SizedBox(width: 12), PlayPauseButton(), SizedBox(width: 12), NextButton()],
    );
  }
}
