import 'package:flutter/material.dart';
import 'package:jellyflut/components/selectable_back_button.dart';
import 'package:jellyflut/screens/stream/components/controls/bottom_row_player_controls.dart';
import 'package:jellyflut/screens/stream/components/player_infos/player_infos.dart';

import '../controls/show_channel_button.dart';
import '../player_infos/subtitle_box.dart';

class CommonControlsDesktop extends StatefulWidget {
  const CommonControlsDesktop({super.key});

  @override
  State<CommonControlsDesktop> createState() => _CommonControlsDesktopState();
}

class _CommonControlsDesktopState extends State<CommonControlsDesktop> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (c, cc) => Stack(alignment: Alignment.center, children: [
              controls(),
              Positioned.fill(
                top: cc.maxHeight * 0.6,
                child: Align(alignment: Alignment.bottomCenter, child: SubtitleBox()),
              ),
            ]));
  }

  Widget controls() {
    return Column(
      children: const [SizedBox(height: 12), TopRow(), Spacer(), BottomRowPlayerControls()],
    );
  }
}

class TopRow extends StatelessWidget {
  const TopRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SelectableBackButton(),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [ItemTitle(), ItemParentTitlePhone()],
          ),
        ),
      ),
      const Spacer(),
      const ShowChannelButton()
    ]);
  }
}
