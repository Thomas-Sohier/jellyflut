import 'package:flutter/material.dart';
import 'package:jellyflut/components/selectable_back_button.dart';
import 'package:jellyflut/screens/stream/components/controls/current_duration_player.dart';
import 'package:jellyflut/screens/stream/components/controls/current_position_player.dart';
import 'package:jellyflut/screens/stream/components/controls/fullscreen_button.dart';
import 'package:jellyflut/screens/stream/components/controls/pip_button.dart';
import 'package:jellyflut/screens/stream/components/controls/play_pause_button.dart';
import 'package:jellyflut/screens/stream/components/controls/video_player_progress_bar.dart';
import 'package:jellyflut/screens/stream/components/player_infos/player_infos.dart';
import 'package:jellyflut/screens/stream/components/player_infos/transcode_state.dart';
import 'package:universal_io/io.dart';

import '../controls/audio_button_selector.dart';
import '../controls/backward_button.dart';
import '../controls/chapter_button.dart';
import '../controls/forward_button.dart';
import '../controls/show_channel_button.dart';
import '../controls/subtitle_button_selector.dart';
import '../player_infos/subtitle_box.dart';

class CommonControlsPhone extends StatefulWidget {
  const CommonControlsPhone({super.key});

  @override
  State<CommonControlsPhone> createState() => _CommonControlsPhoneState();
}

class _CommonControlsPhoneState extends State<CommonControlsPhone> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: Colors.black38,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
                child: Column(
              children: const [
                SizedBox(height: 12),
                Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: TopRow())),
                Expanded(child: Controls()),
                Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: BottomRow())),
                SizedBox(height: 24),
              ],
            )),
            Positioned.fill(child: const Align(alignment: Alignment.bottomCenter, child: SubtitleBox())),
          ],
        ));
  }
}

class TopRow extends StatelessWidget {
  const TopRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const BackButton(),
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

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      return Row(children: const [SelectableBackButton(), SizedBox(width: 12)]);
    }
    return const SizedBox();
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
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
