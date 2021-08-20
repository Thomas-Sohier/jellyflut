import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/outlinedButtonSelector.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';

class SubtitleButtonSelector extends StatefulWidget {
  SubtitleButtonSelector({Key? key}) : super(key: key);

  @override
  _SubtitleButtonSelectorState createState() => _SubtitleButtonSelectorState();
}

class _SubtitleButtonSelectorState extends State<SubtitleButtonSelector> {
  late final FocusNode _node;
  late final StreamingProvider streamingProvider;
  late int subtitleSelectedIndex;

  @override
  void initState() {
    super.initState();
    _node = FocusNode(canRequestFocus: false, descendantsAreFocusable: false);
    streamingProvider = StreamingProvider();
    subtitleSelectedIndex = streamingProvider.selectedSubtitleTrack?.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        node: _node,
        onPressed: () => {},
        shape: CircleBorder(),
        child: changeSubtitle(context));
  }

  Widget changeSubtitle(BuildContext context) {
    return FutureBuilder<List<Subtitle>>(
      future: streamingProvider.commonStream!.getSubtitles(),
      builder: (context, snapshot) => PopupMenuButton<Subtitle>(
          icon: Icon(
            Icons.subtitles,
            color: Colors.white,
          ),
          tooltip: 'Select a subtitle',
          onSelected: (Subtitle subtitle) => setSubtitle(subtitle),
          itemBuilder: (context) {
            if (snapshot.hasData) {
              return _audioTracksListTile(snapshot.data!);
            }
            return <PopupMenuEntry<Subtitle>>[];
          }),
    );
  }

  List<PopupMenuEntry<Subtitle>> _audioTracksListTile(
      List<Subtitle> audioTracks) {
    final list = <PopupMenuEntry<Subtitle>>[];
    list.add(
      PopupMenuItem(
        child: Text('Select a subtitle'),
      ),
    );
    list.add(
      PopupMenuDivider(
        height: 10,
      ),
    );
    if (audioTracks.isEmpty) {
      list.add(PopupMenuItem(enabled: false, child: Text('No subtitles')));
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
