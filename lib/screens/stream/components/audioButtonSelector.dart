import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/globals.dart';
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
    _node = FocusNode();
    streamingProvider = StreamingProvider();
    audioSelectedIndex = streamingProvider.selectedAudioTrack?.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
      node: _node,
      onPressed: () => changeAudio(context),
      shape: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.audiotrack,
          color: Colors.white,
        ),
      ),
    );
  }

  void changeAudio(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Select audio source'),
              content: Container(
                  width: 250,
                  constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
                  child: FutureBuilder<List<AudioTrack>>(
                      future: streamingProvider.commonStream!.getAudioTracks(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          final audioTracks = snapshot.data!;
                          return ListView.builder(
                            itemCount: audioTracks.length,
                            itemBuilder: (context, index) {
                              return _audioTracksListTile(index, audioTracks);
                            },
                          );
                        }
                        return Center(
                          child: Text('No audio tracks found'),
                        );
                      })));
        });
  }

  Widget _audioTracksListTile(int index, List<AudioTrack> audioTracks) {
    return ListTile(
        selected: isAudioSelected(audioTracks[index]),
        title: Text(
          audioTracks[index].name,
        ),
        onTap: () {
          setAudioTrack(audioTracks[index]);
          customRouter.pop(
            index < audioTracks.length ? audioTracks[index] : -1,
          );
        });
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
