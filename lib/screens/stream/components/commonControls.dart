import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/stream/components/playPauseButton.dart';
import 'package:jellyflut/screens/stream/components/videoPlayerprogressBar.dart';
import 'package:jellyflut/screens/stream/model/audiotrack.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:jellyflut/shared/toast.dart';
import 'package:provider/provider.dart';

class CommonControls extends StatefulWidget {
  final bool isComputer;

  const CommonControls({Key? key, this.isComputer = false}) : super(key: key);

  @override
  _CommonControlsState createState() => _CommonControlsState();
}

class _CommonControlsState extends State<CommonControls> {
  bool _visible = true;
  late Timer _timer;
  int subtitleSelectedIndex = 0;
  int audioSelectedIndex = 0;
  late StreamModel streamModel;
  late FToast fToast;

  final Shader linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [jellyLightBLue, jellyLightPurple],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void initState() {
    streamModel = StreamModel();
    streamModel.commonStream?.initListener();
    fToast = FToast();
    fToast.init(navigatorKey.currentState!.context);
    _timer = Timer(
        Duration(seconds: 5),
        () => setState(() {
              _visible = false;
            }));
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    streamModel.timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: streamModel,
        child: GestureDetector(
            onTap: () => autoHideControl(),
            child: visibility(
                child: Stack(
              children: [blackGradient(), controls()],
            ))));
  }

  Widget visibility({required Widget child}) {
    return Material(
        color: Colors.transparent,
        child: Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: _visible,
            child: child));
  }

  Widget blackGradient() {
    return Container(
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black87,
            Colors.transparent,
            Colors.transparent,
            Colors.black54
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.3, 0.8, 1],
        ),
      ),
    );
  }

  Widget controls() {
    return Column(
      children: [topRow(), Spacer(), bottomRow()],
    );
  }

  Widget topRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isComputer)
            BackButton(
              color: Colors.white,
            ),
          Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      streamModel.item!.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    streamModel.item?.hasParent() != null
                        ? Text(
                            streamModel.item!.parentName(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                foreground: Paint()..shader = linearGradient,
                                fontSize: 14),
                          )
                        : Container(),
                  ],
                ),
              )),
          Expanded(
              flex: 5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: streamModel.isDirectPlay!
                          ? gradientMask(
                              child: Icon(Icons.play_for_work,
                                  color: Colors.white))
                          : gradientMask(
                              child: Icon(
                              Icons.cloud_outlined,
                              color: Colors.white,
                            ))),
                  InkWell(
                    onTap: () {
                      try {
                        streamModel.commonStream?.pip();
                      } catch (message) {
                        showToast(message.toString(), fToast);
                      }
                    },
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.picture_in_picture,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      changeSubtitle(context);
                    },
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.closed_caption,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        changeAudio(context);
                      },
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.audiotrack,
                          color: Colors.white,
                        ),
                      ))
                ],
              ))
        ]);
  }

  Widget bottomRow() {
    return Row(children: [
      Expanded(flex: 1, child: PlayPauseButton()),
      Expanded(flex: 9, child: VideoPlayerProgressBar()),
      Spacer(flex: 1)
    ]);
  }

  Future<void> autoHideControl() async {
    _timer.cancel();
    setState(() {
      _visible = !_visible;
    });
    _timer = Timer(
        Duration(seconds: 5),
        () => setState(() {
              _visible = false;
            }));
  }

// TODO rework with commonstreams

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
                      future: streamModel.commonStream!.getSubtitles(),
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
            : disableSubtitles(index);
        Navigator.pop(
          context,
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

  void disableSubtitles(int index) {
    subtitleSelectedIndex = index;
    streamModel.commonStream!.disableSubtitles();
  }

  void setSubtitle(Subtitle subtitle) async {
    subtitleSelectedIndex = subtitle.index;
    streamModel.commonStream!.setSubtitle(subtitle.index);
  }

  // void changeAudio(BuildContext context) {
  //   var hlsAudios =
  //       streamModel.betterPlayerController?.betterPlayerAsmsAudioTracks;
  //   var remoteAudios = streamModel.item?.mediaStreams != null
  //       ? streamModel.item!.mediaStreams!
  //           .where((element) => element.type.trim().toLowerCase() == 'audio')
  //           .toList()
  //       : null;
  //   if (hlsAudios != null && hlsAudios.isNotEmpty) {
  //     dialogHLSAudio(hlsAudios);
  //   } else if (remoteAudios != null && remoteAudios.isNotEmpty) {
  //     dialogRemoteAudio(remoteAudios);
  //   } else {
  //     showToast('No audios found', fToast);
  //   }
  // }

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
                      future: streamModel.commonStream!.getAudioTracks(),
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
        selected: isAudioSelected(index),
        title: Text(
          audioTracks[index].name,
        ),
        onTap: () {
          setAudioTrack(audioTracks[index]);
          Navigator.pop(
            context,
            index < audioTracks.length ? audioTracks[index] : -1,
          );
        });
  }

  bool isAudioSelected(int trackIndex) {
    return subtitleSelectedIndex == trackIndex;
  }

  void setAudioTrack(AudioTrack audioTrack) async {
    audioSelectedIndex = audioTrack.index;
    streamModel.commonStream!.setAudioTrack(audioTrack);
  }

/*
  void changeAudioTrack(String url) async {
    var tick = streamModel.betterPlayerController!.videoPlayerController!.value
        .position.inMicroseconds;
    var dataSource = BetterPlayerDataSource.network(url,
        subtitles: await getSubtitles(streamModel.item!));

    // BetterPlayerDataSource.file(url);

    streamModel.betterPlayerController!.betterPlayerSubtitlesSourceList.clear();
    await streamModel.betterPlayerController!.setupDataSource(dataSource);
    streamModel.betterPlayerController!.playNextVideo();
    await streamModel.betterPlayerController!
        .seekTo(Duration(microseconds: tick));
  }
  */
}
