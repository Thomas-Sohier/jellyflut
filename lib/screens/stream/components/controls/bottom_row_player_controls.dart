import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/stream/components/controls/backward_button.dart';
import 'package:jellyflut/screens/stream/components/controls/forward_button.dart';
import 'package:jellyflut/screens/stream/components/controls/fullscreen_button.dart';
import 'package:jellyflut/screens/stream/components/controls/pip_button.dart';
import 'package:jellyflut/screens/stream/components/controls/play_pause_button.dart';
import 'package:jellyflut/screens/stream/components/controls/video_player_progress_bar.dart';

import '../player_infos/transcode_state.dart';
import 'audio_button_selector.dart';
import 'chapter_button.dart';
import 'subtitle_button_selector.dart';

class BottomRowPlayerControls extends StatelessWidget {
  const BottomRowPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRect(
            child: ColoredBox(
          color: Colors.black12,
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TranscodeState(),
                          const Spacer(),
                          BackwardButton(),
                          PlayPauseButton(),
                          ForwardButton(),
                          const Spacer(),
                          PipButton(),
                          ChapterButton(),
                          SubtitleButtonSelector(),
                          AudioButtonSelector(),
                          FullscreenButton()
                        ]),
                  ),
                  const SizedBox(height: 24)
                ],
              )),
        )),
        VideoPlayerProgressBar(),
      ],
    );
  }
}
