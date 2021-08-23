import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/outlinedButtonSelector.dart';
import 'package:jellyflut/screens/stream/model/audiotrack.dart';

class AudioButtonSelector extends StatefulWidget {
  AudioButtonSelector({Key? key}) : super(key: key);

  @override
  _AudioButtonSelectorState createState() => _AudioButtonSelectorState();
}

class _AudioButtonSelectorState extends State<AudioButtonSelector> {
  late final FocusNode _node;
  late final StreamingProvider streamingProvider;
  late int audioSelectedIndex;

  @override
  void initState() {
    super.initState();
    _node = FocusNode(
        canRequestFocus: false,
        descendantsAreFocusable: false,
        skipTraversal: true);
    streamingProvider = StreamingProvider();
    audioSelectedIndex = streamingProvider.selectedAudioTrack?.index ?? 0;
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
        onPressed: () => {},
        shape: CircleBorder(),
        child: changeAudio(context));
  }

  Widget changeAudio(BuildContext context) {
    return FutureBuilder<List<AudioTrack>>(
      future: streamingProvider.commonStream!.getAudioTracks(),
      builder: (context, snapshot) => PopupMenuButton<AudioTrack>(
          icon: Icon(
            Icons.audiotrack,
            color: Colors.white,
          ),
          tooltip: 'Select audio source',
          onSelected: (AudioTrack audio) => setAudioTrack(audio),
          itemBuilder: (context) {
            if (snapshot.hasData) {
              return _audioTracksListTile(snapshot.data!);
            }
            return <PopupMenuEntry<AudioTrack>>[];
          }),
    );
  }

  List<PopupMenuEntry<AudioTrack>> _audioTracksListTile(
      List<AudioTrack> audioTracks) {
    final list = <PopupMenuEntry<AudioTrack>>[];
    list.add(
      PopupMenuItem(
        child: Text('Select audio source'),
      ),
    );
    list.add(
      PopupMenuDivider(
        height: 10,
      ),
    );
    if (audioTracks.isEmpty) {
      list.add(PopupMenuItem(enabled: false, child: Text('No audio source')));
      return list;
    }
    for (var index = 0; index < audioTracks.length; index++) {
      list.add(
        CheckedPopupMenuItem(
          value: audioTracks[index],
          checked: isAudioSelected(audioTracks[index]),
          child: Text(audioTracks[index].name),
        ),
      );
    }
    return list;
  }

  bool isAudioSelected(AudioTrack audioTrack) {
    return audioSelectedIndex == audioTrack.index;
  }

  void setAudioTrack(AudioTrack audioTrack) async {
    audioSelectedIndex = audioTrack.index;
    streamingProvider.setAudioStreamIndex(audioTrack);
    streamingProvider.commonStream!.setAudioTrack(audioTrack);
  }
}
