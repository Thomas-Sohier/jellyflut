import 'package:flutter/material.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/shared/shared.dart';

class SongDurationPosition extends StatelessWidget {
  const SongDurationPosition({super.key});

  @override
  Widget build(BuildContext context) {
    final musicProvider = MusicProvider();
    return Row(
      children: [
        StreamBuilder<Duration?>(
            stream: musicProvider.getPositionStream(),
            builder: (context, snapshot) => Text(
                  snapshot.data != null
                      ? printDuration(snapshot.data!)
                      : '0.00',
                  style: Theme.of(context).textTheme.bodyText1,
                )),
        Spacer(),
        StreamBuilder<Duration?>(
            stream: musicProvider.getDurationStream(),
            builder: (context, snapshot) => Text(
                snapshot.data != null
                    ? printDuration(musicProvider.getDuration())
                    : '∞',
                style: Theme.of(context).textTheme.bodyText1))
      ],
    );
  }
}
