import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/api/stream.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/mediaStream.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:jellyflut/shared/toast.dart';

class ControlsVLC extends StatefulWidget {
  ControlsVLC({Key? key, required this.controller}) : super(key: key);

  final VlcPlayerController controller;

  @override
  _ControlsVLCState createState() => _ControlsVLCState();
}

class _ControlsVLCState extends State<ControlsVLC> {
  final Shader linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [jellyLightBLue, jellyLightPurple],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  bool _visible = false;
  late VlcPlayerController controller;
  late StreamModel streamModel;
  late Timer _timer;
  late FToast fToast;

  @override
  void initState() {
    streamModel = StreamModel();
    controller = widget.controller;
    fToast = FToast();
    fToast.init(navigatorKey.currentState!.context);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => autoHideControl(),
        child: visibility(
            child: Stack(
          children: [blackGradient(), controls()],
        )));
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
                      _getSubtitleTracks();
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
                        _getAudioTracks();
                      },
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.audiotrack,
                          color: Colors.white,
                        ),
                      )),
                  InkWell(
                      onTap: () {
                        _getRendererDevices();
                      },
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.cast,
                          color: Colors.white,
                        ),
                      ))
                ],
              ))
        ]);
  }

  Widget bottomRow() {
    return Row(children: [
      InkWell(
          onTap: () async {
            widget.controller.value.isPlaying
                ? await widget.controller.pause()
                : await widget.controller.play();
          },
          borderRadius: BorderRadius.all(Radius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              widget.controller.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
            ),
          )),
      Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            printDuration(widget.controller.value.position),
            style: TextStyle(color: Colors.white),
          )),
      Expanded(
          flex: 1,
          child: Slider(
            activeColor: Colors.white,
            inactiveColor: Colors.white30,
            min: 0,
            max: widget.controller.value.duration.inSeconds.toDouble() != 0
                ? widget.controller.value.duration.inSeconds.toDouble()
                : widget.controller.value.position.inSeconds.toDouble() + 1,
            value: widget.controller.value.position.inSeconds.toDouble(),
            onChanged: (value) =>
                controller.seekTo(Duration(seconds: value.toInt())),
            onChangeEnd: (value) {
              widget.controller.seekTo(Duration(
                  seconds: widget.controller.value.position.inSeconds));
            },
          )),
      Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            printDuration(
                Duration(seconds: widget.controller.value.duration.inSeconds)),
            style: TextStyle(color: Colors.white),
          )),
      // InkWell(
      //     onTap: () {
      //       // TODO
      //     },
      //     borderRadius: BorderRadius.all(Radius.circular(50)),
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Icon(
      //         streamModel.betterPlayerController.isFullScreen
      //             ? Icons.fullscreen_exit
      //             : Icons.fullscreen,
      //         color: Colors.white,
      //       ),
      //     )),
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

  void _getSubtitleTracks() async {
    if (!controller.value.isPlaying) return;

    var subtitleTracks = await controller.getSpuTracks();
    var subtitlesRemoteTracks = streamModel.item != null
        ? streamModel.item!.mediaStreams!
            .where((element) => element.type.trim().toLowerCase() == 'subtitle')
            .toList()
        : null;

    if (streamModel.isDirectPlay!) {
      setEmbedSubtitlesTracks(subtitleTracks);
    } else {
      setRemoteSubtitlesTracks(subtitlesRemoteTracks!);
    }
  }

  void setEmbedSubtitlesTracks(Map<int, String> subtitleTracks) async {
    var selectedSubId = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Subtitle'),
          content: Container(
            width: 250,
            constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
            child: ListView.builder(
              itemCount: subtitleTracks.keys.length + 1,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    index < subtitleTracks.keys.length
                        ? subtitleTracks.values.elementAt(index).toString()
                        : 'Disable',
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                      index < subtitleTracks.keys.length
                          ? subtitleTracks.keys.elementAt(index)
                          : -1,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
    if (selectedSubId != null) {
      await controller.setSpuTrack(selectedSubId);
    }
  }

  void setRemoteSubtitlesTracks(List<MediaStream> subtitlesRemoteTracks) async {
    var selectedSub = await showDialog<MediaStream>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Subtitle'),
          content: Container(
            constraints: BoxConstraints(maxHeight: 300, maxWidth: 250),
            child: ListView.builder(
              itemCount: subtitlesRemoteTracks.length + 1,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    index < subtitlesRemoteTracks.length
                        ? subtitlesRemoteTracks[index].displayTitle!
                        : 'Disable',
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                      index < subtitlesRemoteTracks.length
                          ? subtitlesRemoteTracks[index]
                          : -1,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
    if (selectedSub != null) {
      var url = await getNewSubtitleSource(selectedSub.index!,
          playbackTick: controller.value.position);
      await controller.setMediaFromNetwork(url, autoPlay: true);
    }
  }

  void _getAudioTracks() async {
    if (!controller.value.isPlaying) return;

    var audioTracks = await controller.getAudioTracks();
    var remoteAudiosTracks = streamModel.item != null
        ? streamModel.item!.mediaStreams!
            .where((element) => element.type.trim().toLowerCase() == 'audio')
            .toList()
        : null;
    //
    if (streamModel.isDirectPlay!) {
      setEmbedAudioTracks(audioTracks);
    } else {
      setRemoteAudiosTracks(remoteAudiosTracks!);
    }
  }

  void setEmbedAudioTracks(Map<int, String> audioTracks) async {
    var selectedAudioTrackId = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Audio'),
          content: Container(
            width: 250,
            constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
            child: ListView.builder(
              itemCount: audioTracks.keys.length + 1,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    index < audioTracks.keys.length
                        ? audioTracks.values.elementAt(index).toString()
                        : 'Disable',
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                      index < audioTracks.keys.length
                          ? audioTracks.keys.elementAt(index)
                          : -1,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
    if (selectedAudioTrackId != null) {
      await controller.setAudioTrack(selectedAudioTrackId);
    }
  }

  void setRemoteAudiosTracks(List<MediaStream> remoteAudiosTracks) async {
    var selectedAudioTrack = await showDialog<MediaStream>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Audio'),
          content: Container(
            width: 250,
            constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
            child: ListView.builder(
              itemCount: remoteAudiosTracks.length + 1,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    index < remoteAudiosTracks.length
                        ? remoteAudiosTracks[index].displayTitle!
                        : 'Disable',
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                      index < remoteAudiosTracks.length
                          ? remoteAudiosTracks[index]
                          : -1,
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
    if (selectedAudioTrack != null) {
      var url = await getNewAudioSource(selectedAudioTrack.index!,
          playbackTick: controller.value.position);
      await controller.setMediaFromNetwork(url, autoPlay: true);
    }
  }

  void _getRendererDevices() async {
    var castDevices = await controller.getRendererDevices();
    //
    if (castDevices.isNotEmpty) {
      var selectedCastDeviceName = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Display Devices'),
            content: Container(
              width: 250,
              constraints: BoxConstraints(minHeight: 100, maxHeight: 300),
              child: ListView.builder(
                itemCount: castDevices.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < castDevices.keys.length
                          ? castDevices.values.elementAt(index).toString()
                          : 'Disconnect',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < castDevices.keys.length
                            ? castDevices.keys.elementAt(index)
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      await controller.castToRenderer(selectedCastDeviceName);
    } else {
      showToast('No Display Device Found!', fToast);
    }
  }
}
