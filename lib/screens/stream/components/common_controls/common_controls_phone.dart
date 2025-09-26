import 'package:flutter/material.dart';
import 'package:jellyflut/components/selectable_back_button.dart';
import 'package:jellyflut/screens/stream/components/controls/backward_button.dart';
import 'package:jellyflut/screens/stream/components/controls/chapter_button.dart';
import 'package:jellyflut/screens/stream/components/controls/current_duration_player.dart';
import 'package:jellyflut/screens/stream/components/controls/current_position_player.dart';
import 'package:jellyflut/screens/stream/components/controls/forward_button.dart';
import 'package:jellyflut/screens/stream/components/controls/fullscreen_button.dart';
import 'package:jellyflut/screens/stream/components/controls/pip_button.dart';
import 'package:jellyflut/screens/stream/components/controls/play_pause_button.dart';
import 'package:jellyflut/screens/stream/components/controls/show_channel_button.dart';
import 'package:jellyflut/screens/stream/components/controls/subtitle_button_selector.dart';
import 'package:jellyflut/screens/stream/components/controls/video_player_progress_bar.dart';
import 'package:jellyflut/screens/stream/components/player_infos/player_infos.dart';
import 'package:jellyflut/screens/stream/components/player_infos/subtitle_box.dart';
import 'package:jellyflut/screens/stream/components/player_infos/transcode_state.dart';
import 'package:universal_io/io.dart';

import '../controls/audio_button_selector.dart';

class CommonControlsPhone extends StatelessWidget {
  const CommonControlsPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
        // Ajout de 'const' ici et dans les enfants si possible
        color: Colors.black38,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
                child: Column(
              children: [
                SizedBox(height: 12),
                Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: TopRow())),
                Expanded(child: Controls()),
                Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: BottomRow())),
                SizedBox(height: 24),
              ],
            )),
            Positioned.fill(child: Align(alignment: Alignment.bottomCenter, child: SubtitleBox())),
          ],
        ));
  }
}

class TopRow extends StatelessWidget {
  const TopRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Utilisation du nouveau nom pour plus de clarté
      const PlatformBackButton(),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [ItemTitlePhone(), ItemParentTitlePhone()],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          PipButton(),
          ChapterButton(),
          SubtitleButtonSelector(),
          AudioButtonSelector(),
          ShowChannelButton(),
          TranscodeState()
        ],
      )
    ]);
  }
}

// 2. Renommé pour plus de clarté (ce n'est pas le BackButton par défaut de Flutter)
class PlatformBackButton extends StatelessWidget {
  const PlatformBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      return const Row(children: [SelectableBackButton(), SizedBox(width: 12)]);
    }
    return const SizedBox.shrink(); // Utilisation de SizedBox.shrink() pour un widget vide
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      // Ajout de const
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BackwardButton(size: 42),
        SizedBox(width: 12),
        PlayPauseButton(size: 42),
        SizedBox(width: 12),
        ForwardButton(size: 42),
      ],
    );
  }
}

class BottomRow extends StatelessWidget {
  const BottomRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          const CurrentPositionPlayer(),
          const Text('/'),
          const CurrentDurationPlayer(),
          const Spacer(),
          if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) const FullscreenButton()
        ]),
        const VideoPlayerProgressBar(barHeight: 4, thumbRadius: 8),
        const SizedBox(height: 24),
      ],
    );
  }
}
