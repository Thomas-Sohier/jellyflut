import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/stream.dart';
import 'package:jellyflut/models/mediaStream.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/stream/streamBP.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';

class Controls extends StatefulWidget {
  const Controls();

  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  bool _visible = false;
  Timer _timer;
  int _playBackTime = 0;
  int subtitleSelectedIndex;
  int audioSelectedIndex;
  StreamModel streamModel;

  final Shader linearGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [jellyLightBLue, jellyLightPurple],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void initState() {
    streamModel = StreamModel();
    streamModel.betterPlayerController.videoPlayerController.addListener(() {
      if (mounted) {
        setState(() {
          _playBackTime = streamModel.betterPlayerController
                  .videoPlayerController.value.position.inSeconds ??
              0;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
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

  Widget visibility({@required Widget child}) {
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
                      streamModel.item.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    streamModel.item.hasParent() != null
                        ? Text(
                            streamModel.item.parentName(),
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
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: streamModel.playBackInfos.mediaSources.first
                                  .transcodingUrl !=
                              null
                          ? gradientMask(
                              child: Icon(
                              Icons.cloud_outlined,
                              color: Colors.white,
                            ))
                          : gradientMask(
                              child: Icon(Icons.play_for_work,
                                  color: Colors.white))),
                  InkWell(
                    onTap: () => streamModel.betterPlayerController
                        .enablePictureInPicture(streamModel
                            .betterPlayerController.betterPlayerGlobalKey),
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
                  // TODO make audio change works
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
    var _controller = streamModel.betterPlayerController.videoPlayerController;
    return Row(children: [
      InkWell(
          onTap: () {
            setState(() {
              streamModel.betterPlayerController.videoPlayerController.value
                      .isPlaying
                  ? StreamModel().betterPlayerController.pause()
                  : StreamModel().betterPlayerController.play();
            });
          },
          borderRadius: BorderRadius.all(Radius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              streamModel.betterPlayerController.videoPlayerController.value
                      .isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
            ),
          )),
      Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            printDuration(Duration(seconds: _playBackTime)),
            style: TextStyle(color: Colors.white),
          )),
      Expanded(
          flex: 1,
          child: Slider(
            activeColor: Colors.white,
            inactiveColor: Colors.white30,
            min: 0,
            max: _controller.value.duration.inSeconds.toDouble() != 0
                ? _controller.value.duration.inSeconds.toDouble()
                : _playBackTime.toDouble() + 1,
            value: _playBackTime.toDouble(),
            onChanged: (value) {
              setState(() {
                _playBackTime = value.toInt();
              });
            },
            onChangeEnd: (value) {
              _controller.seekTo(Duration(seconds: _playBackTime));
            },
          )),
      Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Text(
            printDuration(
                Duration(seconds: _controller.value.duration.inSeconds)),
            style: TextStyle(color: Colors.white),
          )),
      InkWell(
          onTap: () {
            setState(() {
              streamModel.betterPlayerController.toggleFullScreen();
            });
          },
          borderRadius: BorderRadius.all(Radius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              streamModel.betterPlayerController.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
            ),
          )),
    ]);
  }

  Future<void> autoHideControl() async {
    if (streamModel.betterPlayerController != null) {
      if (_timer != null) _timer.cancel();
      setState(() {
        _visible = !_visible;
      });
      _timer = Timer(
          Duration(seconds: 5),
          () => setState(() {
                _visible = false;
              }));
    }
  }

  void changeSubtitle(BuildContext context) {
    var subtitles = streamModel.item.mediaStreams
        .where((element) => element.type.trim().toLowerCase() == 'subtitle')
        .toList();
    if (subtitles != null && subtitles.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Select Subtitle'),
              content: Container(
                constraints: BoxConstraints(maxWidth: 150),
                width: double.maxFinite,
                height: 250,
                child: ListView.builder(
                  itemCount: subtitles.length + 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      selected: isSubtitleSelected(index, subtitles),
                      title: Text(
                        index < subtitles.length
                            ? subtitles[index].displayTitle
                            : 'Disable',
                      ),
                      onTap: () {
                        index < subtitles.length
                            ? setSubtitles(index, subtitles)
                            : disableSubtitles(index);
                        Navigator.pop(
                          context,
                          index < subtitles.length ? subtitles[index] : -1,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          });
    } else {
      showToast('No subtitles found');
    }
  }

  bool isSubtitleSelected(int index, List<MediaStream> listSubtitles) {
    if (subtitleSelectedIndex == listSubtitles.length &&
        index == listSubtitles.length) {
      return true;
    } else if (index + 1 > listSubtitles.length || index < 0) {
      return false;
    } else if (subtitleSelectedIndex == index) {
      return true;
    } else if (subtitleSelectedIndex == null &&
        listSubtitles[index].isDefault) {
      return true;
    }
    return false;
  }

  void disableSubtitles(int index) {
    subtitleSelectedIndex = index;
    streamModel.betterPlayerController.subtitlesLines.clear();
  }

  void setSubtitles(int index, List<MediaStream> listSubtitles) async {
    var _itemId = StreamModel().item.id;
    var sub = listSubtitles[index];
    subtitleSelectedIndex = index;
    var mediaSourceId = _itemId.substring(0, 8) +
        '-' +
        _itemId.substring(8, 12) +
        '-' +
        _itemId.substring(12, 16) +
        '-' +
        _itemId.substring(16, 20) +
        '-' +
        _itemId.substring(20, _itemId.length);

    var parsedCodec = sub.codec.substring(sub.codec.indexOf('.') + 1);

    var queryParam = <String, String>{};
    queryParam['api_key'] = apiKey;

    final uri = Uri.https(
        server.url.replaceAll('https://', ''),
        '/Videos/${mediaSourceId}/${_itemId}/Subtitles/${sub.index}/0/Stream.${parsedCodec}',
        queryParam);
    var url = uri.origin + uri.path;
    await streamModel.betterPlayerController.setupSubtitleSource(
        BetterPlayerSubtitlesSource(
            type: BetterPlayerSubtitlesSourceType.network,
            urls: [url],
            name: sub.title));
  }

  void changeAudio(BuildContext context) {
    var audios = streamModel.item.mediaStreams
        .where((element) => element.type.trim().toLowerCase() == 'audio')
        .toList();
    if (audios != null && audios.isNotEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Select audio source'),
              content: Container(
                constraints: BoxConstraints(maxWidth: 150),
                width: double.maxFinite,
                height: 250,
                child: ListView.builder(
                  itemCount: audios.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      selected: isAudioSelected(index, audios),
                      title: Text(
                        audios[index].displayTitle,
                      ),
                      onTap: () {
                        changeAudioSource(audios[index].index,
                                playbackTick: _playBackTime)
                            .then((url) => changeAudioTrack(url));
                        Navigator.pop(
                          context,
                          index < audios.length ? audios[index] : -1,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          });
    } else {
      showToast('No audios found');
    }
  }

  bool isAudioSelected(int index, List<MediaStream> listAudios) {
    if (subtitleSelectedIndex == index) {
      return true;
    } else if (subtitleSelectedIndex == null && listAudios[index].isDefault) {
      return true;
    }
    return false;
  }

  void changeAudioTrack(String url) async {
    var tick = streamModel.betterPlayerController.videoPlayerController.value
        .position.inMicroseconds;
    var dataSource = BetterPlayerDataSource.file(url,
        subtitles: await getSubtitles(streamModel.item));

    // BetterPlayerDataSource.file(url);

    streamModel.betterPlayerController.betterPlayerSubtitlesSourceList.clear();
    await streamModel.betterPlayerController.setupDataSource(dataSource);
    streamModel.betterPlayerController.playNextVideo();
    await streamModel.betterPlayerController
        .seekTo(Duration(microseconds: tick));
  }

  Widget gradientMask({@required Widget child}) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 0.5,
          colors: <Color>[jellyLightBLue, jellyLightPurple],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
