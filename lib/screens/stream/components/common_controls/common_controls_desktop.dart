import 'package:flutter/material.dart';
import 'package:jellyflut/components/selectable_back_button.dart' as bb;
import 'package:jellyflut/screens/stream/components/controls/bottom_row_player_controls.dart';
import 'package:jellyflut/screens/stream/components/player_infos/player_infos.dart';

import '../player_infos/subtitle_box.dart';

class CommonControlsDesktop extends StatefulWidget {
  final bool isComputer;

  const CommonControlsDesktop({super.key, this.isComputer = false});

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
                child: Align(
                    alignment: Alignment.bottomCenter, child: SubtitleBox()),
              ),
            ]));
  }

  Widget controls() {
    return Column(
      children: [
        const SizedBox(height: 12),
        const TopRow(),
        const Spacer(),
        const BottomRowPlayerControls()
      ],
    );
  }
}

class TopRow extends StatelessWidget {
  const TopRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          bb.SelectableBackButton(shadow: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [ItemTitle(), ItemParentTitle()],
              ),
            ),
          ),
        ]);
  }
}
