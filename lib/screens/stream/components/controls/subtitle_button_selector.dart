import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';

class SubtitleButtonSelector extends StatefulWidget {
  SubtitleButtonSelector({Key? key}) : super(key: key);

  @override
  _SubtitleButtonSelectorState createState() => _SubtitleButtonSelectorState();
}

class _SubtitleButtonSelectorState extends State<SubtitleButtonSelector> {
  late final FocusNode _node;
  late final StreamingProvider streamingProvider;
  late final GlobalKey<PopupMenuButtonState<Subtitle>> _popupMenuButtonKey;
  late int subtitleSelectedIndex;

  @override
  void initState() {
    super.initState();
    _node = FocusNode(
        canRequestFocus: false,
        descendantsAreFocusable: false,
        skipTraversal: true);
    streamingProvider = StreamingProvider();
    subtitleSelectedIndex = streamingProvider.selectedSubtitleTrack?.index ?? 0;
    _popupMenuButtonKey = GlobalKey();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        node: _node,
        onPressed: () => _popupMenuButtonKey.currentState?.showButtonMenu(),
        shape: CircleBorder(),
        child: changeSubtitle(context));
  }

  Widget changeSubtitle(BuildContext context) {
    return IgnorePointer(
        child: FutureBuilder<List<Subtitle>>(
      future: streamingProvider.commonStream!.getSubtitles(),
      builder: (context, snapshot) => PopupMenuButton<Subtitle>(
          key: _popupMenuButtonKey,
          icon: Icon(
            Icons.subtitles,
            color: Colors.white,
          ),
          tooltip: 'select_subtitle'.tr(),
          onSelected: (Subtitle subtitle) => setSubtitle(subtitle),
          itemBuilder: (context) {
            if (snapshot.hasData) {
              return _audioTracksListTile(snapshot.data!);
            }
            return <PopupMenuEntry<Subtitle>>[];
          }),
    ));
  }

  List<PopupMenuEntry<Subtitle>> _audioTracksListTile(
      List<Subtitle> audioTracks) {
    final list = <PopupMenuEntry<Subtitle>>[];
    list.add(
      PopupMenuItem(
        child: Text('select_subtitle'.tr()),
      ),
    );
    list.add(
      PopupMenuDivider(
        height: 10,
      ),
    );
    if (audioTracks.isEmpty) {
      list.add(PopupMenuItem(enabled: false, child: Text('no_subtitles'.tr())));
      return list;
    }
    for (var index = 0; index < audioTracks.length; index++) {
      list.add(
        CheckedPopupMenuItem(
          value: audioTracks[index],
          checked: isSelected(audioTracks[index]),
          child: Text(audioTracks[index].name),
        ),
      );
    }
    return list;
  }

  bool isSelected(Subtitle subtitle) {
    return subtitleSelectedIndex == subtitle.index;
  }

  void disableSubtitles(Subtitle subtitle) {
    subtitleSelectedIndex = subtitle.index;
    streamingProvider.commonStream!.disableSubtitles();
  }

  void setSubtitle(Subtitle subtitle) async {
    subtitleSelectedIndex = subtitle.index;
    streamingProvider.setSubtitleStreamIndex(subtitle);
    streamingProvider.commonStream!.setSubtitle(subtitle);
  }
}
