import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/stream/components/controls/backward_button.dart';
import 'package:jellyflut/screens/stream/components/controls/forward_button.dart';
import 'package:jellyflut/screens/stream/components/controls/fullscreen_button.dart';
import 'package:jellyflut/screens/stream/components/controls/play_pause_button.dart';
import 'package:jellyflut/screens/stream/components/controls/video_player_progress_bar.dart';
import 'package:jellyflut/shared/responsive_builder.dart';
import '../player_infos/subtitle_box.dart';
import 'chapter_button.dart';

class BottomRowPlayerControls extends StatelessWidget {
  const BottomRowPlayerControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder.builder(
        mobile: () => smallBottomRow(),
        tablet: () => largeBottomRow(),
        desktop: () => largeBottomRow());
  }

  Widget smallBottomRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: PlayPauseButton()),
          Expanded(flex: 9, child: VideoPlayerProgressBar()),
          Spacer(flex: 1)
        ]);
  }

  Widget largeBottomRow() {
    return Column(
      children: [
        // Row(children: [SubtitleBox()]),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 1),
              Flexible(flex: 8, child: VideoPlayerProgressBar()),
              Spacer(flex: 1)
            ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackwardButton(),
              PlayPauseButton(),
              ForwardButton(),
              ChapterButton(),
              FullscreenButton()
            ]),
      ],
    );
  }
}
