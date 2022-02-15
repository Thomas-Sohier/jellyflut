import 'package:flutter/material.dart';

import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';
import 'package:jellyflut/screens/musicPlayer/components/next_button.dart';
import 'package:jellyflut/screens/musicPlayer/components/prev_button.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_colors.dart';

class SongControls extends StatefulWidget {
  final Color color;
  final Color backgroundColor;
  SongControls({Key? key, required this.color, required this.backgroundColor})
      : super(key: key);

  @override
  _SongControlsState createState() => _SongControlsState();
}

class _SongControlsState extends State<SongControls> {
  late final MusicProvider musicProvider;
  final List<BoxShadow> shadows = [
    BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: 2)
  ];

  @override
  void initState() {
    musicProvider = MusicProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AudioColors>(
        stream: musicProvider.getColorcontroller,
        initialData: AudioColors(),
        builder: (context, snapshotColor) => controls(snapshotColor.data!));
  }

  Widget controls(final AudioColors audioColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PrevButton(
            color: audioColors.foregroundColor,
            backgroundColor: audioColors.backgroundColor2),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                  color: audioColors.backgroundColor2,
                  boxShadow: shadows,
                  shape: BoxShape.circle),
              child: StreamBuilder<bool>(
                stream: musicProvider.isPlaying(),
                builder: (context, snapshot) => OutlinedButtonSelector(
                    onPressed: () => isPlaying(snapshot.data)
                        ? musicProvider.pause()
                        : musicProvider.play(),
                    shape: CircleBorder(),
                    child: Icon(
                      isPlaying(snapshot.data) ? Icons.pause : Icons.play_arrow,
                      color: audioColors.foregroundColor,
                      size: 42,
                    )),
              )),
        ),
        NextButton(
            color: audioColors.foregroundColor,
            backgroundColor: audioColors.backgroundColor2)
      ],
    );
  }

  bool isPlaying(bool? isplaying) {
    if (isplaying == null) return false;
    return isplaying;
  }
}
