import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/screens/stream/components/controls/backward_button.dart';
import 'package:jellyflut/screens/stream/components/controls/current_duration_player.dart';
import 'package:jellyflut/screens/stream/components/controls/current_position_player.dart';
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
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Row(children: [const CurrentPositionPlayer(), const Spacer(), const CurrentDurationPlayer()]),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(children: [const TranscodeState()]),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const BackwardButton(),
                                      const PlayPauseButton(),
                                      const ForwardButton(),
                                    ]),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const PipButton(),
                                      const ChapterButton(),
                                      const SubtitleButtonSelector(),
                                      const AudioButtonSelector(),
                                      const FullscreenButton()
                                    ]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16)
                        ],
                      )),
                ))),
        const VideoPlayerProgressBar(barCapShape: BarCapShape.square),
      ],
    );
  }
}
