import 'package:flutter/widgets.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/screens/stream/components/backwardButton.dart';
import 'package:jellyflut/screens/stream/components/forwardButton.dart';
import 'package:jellyflut/screens/stream/components/playPauseButton.dart';
import 'package:jellyflut/screens/stream/components/videoPlayerProgressBar.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BottomRowPlayerControls extends StatelessWidget {
  const BottomRowPlayerControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        breakpoints: screenBreakpoints,
        mobile: (BuildContext context) => smallBottomRow(),
        tablet: (BuildContext context) => largeBottomRow(),
        desktop: (BuildContext context) => largeBottomRow());
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
            children: [BackwardButton(), PlayPauseButton(), ForwardButton()]),
        SizedBox(height: 12)
      ],
    );
  }
}
