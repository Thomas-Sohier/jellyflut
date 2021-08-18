import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/globals.dart';
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
    _node = FocusNode();
    streamingProvider = StreamingProvider();
    subtitleSelectedIndex = streamingProvider.selectedSubtitleTrack?.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      node: _node,
      onPressed: () => changeSubtitle(context),
      shape: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.closed_caption,
          color: Colors.white,
        ),
      ),
    );
  }

  void changeSubtitle(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Select Subtitle'),
              content: Container(
                  width: 250,
                  constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
                  child: FutureBuilder<List<Subtitle>>(
                      future: streamingProvider.commonStream!.getSubtitles(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          final subtitles = snapshot.data!;
                          return ListView.builder(
                            itemCount: subtitles.length + 1,
                            itemBuilder: (context, index) {
                              return _subtitleListTile(index, subtitles);
                            },
                          );
                        }
                        return Center(
                          child: Text('No subtitles found'),
                        );
                      })));
        });
  }

  Widget _subtitleListTile(int index, List<Subtitle> subtitles) {
    return ListTile(
      selected: isSelected(index, subtitles),
      title: Text(
        index < subtitles.length ? subtitles[index].name : 'Disable',
      ),
      onTap: () {
        index < subtitles.length
            ? setSubtitle(subtitles[index])
            : disableSubtitles(subtitles[index]);
        customRouter.pop(
          index < subtitles.length ? subtitles[index] : -1,
        );
      },
    );
  }

  bool isSelected(int index, List<Subtitle> subtitles) {
    if (index < subtitles.length) {
      return subtitleSelectedIndex == subtitles[index].index;
    }
    return subtitleSelectedIndex == index;
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
