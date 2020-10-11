import 'package:flutter/services.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/collection.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import '../../globals.dart';
import '../../main.dart';

class Stream extends StatefulWidget {
  @override
  _StreamState createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  Future<void> _initializeVideoPlayerFuture;
  int _playBackTime;

  //The values that are passed when changing quality
  Duration newCurrentPosition;

  VideoPlayerController _controller;
  Item item = new Item();

  @override
  void initState() {
    // final Item media = ModalRoute.of(context).settings.arguments as Item;
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Wakelock.enable();
    Future.delayed(Duration.zero, () {
      setState(() {
        item = ModalRoute.of(context).settings.arguments as Item;
      });
      _controller = VideoPlayerController.network(createURl(item))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            _controller.play();
          });
        }).catchError((onError) {
          showToast("Can't direct play this file, trying to transcode...");
          setNewStream(createTranscodeUrl(item)).catchError((onError) {
            dispose();
            navigatorKey.currentState.pop();
          });
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Stack(children: [
        if (_controller != null)
          _controller.value.initialized
              ? Center(
                  child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ))
              : Center(child: CircularProgressIndicator()),
        Row(children: [
          // Expanded(
          //     flex: 1,
          //     child: Text(
          //       msToHumanReadable(
          //           (_controller.value.position.inMilliseconds / 10).round()),
          //       style: TextStyle(color: Colors.white),
          //     )),
          Expanded(
              flex: 1,
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ))),
          Expanded(
              flex: 3,
              child: Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _controller.seekTo(Duration(milliseconds: value.round()));
                    _controller.play();
                  });
                },
                value: videoCurrentPosition(),
                max: videoMaxPosition(item),
              )),
          // Expanded(
          //     flex: 1,
          //     child: Text(msToHumanReadable((item.runTimeTicks / 10).round()),
          //         style: TextStyle(color: Colors.white))),
          Expanded(
              flex: 1,
              child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.subtitles,
                    color: Colors.white,
                  ))),
          Expanded(
              flex: 1,
              child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.library_music,
                    color: Colors.white,
                  ))),
        ])
      ])),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _controller.value.isPlaying
      //           ? _controller.pause()
      //           : _controller.play();
      //     });
      //   },
      //   child: Icon(
      //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //   ),
      // ),
    );
  }

  double videoCurrentPosition() {
    if (_controller != null) {
      return _controller.value.position.inMilliseconds.toDouble();
    }
    return 0.0;
  }

  double videoMaxPosition(Item item) {
    if (item != null) {
      return item.runTimeTicks.toDouble();
    }
    return 0.0;
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    _controller.dispose();
  }

  String createURl(Item item, {int startTick = 0}) {
    return "${server.url}/Videos/${item.id}/stream.${item.container.split(',').first}?startTimeTicks=${startTick}";
    // String url =
    //     "${server.url}/Videos/${item.id}/stream.avi?startTimeTicks=${startTick}";
    // return url;
  }

  String createTranscodeUrl(Item item) {
    Map<String, String> queryParam = new Map();

    queryParam["MediaSourceId"] = item.id;
    queryParam["VideoCodec"] = "h264";
    queryParam["AudioCodec"] = "mp3,aac";
    queryParam["AudioStreamIndex:"] = "1";
    queryParam["VideoBitrate"] = "148288567";
    queryParam["AudioBitrate"] = "384000";
    queryParam["PlaySessionId"] = "1f4dcede9ece4cb9a8bd558c98e29e88";
    queryParam["api_key"] = apiKey;
    queryParam["TranscodingMaxAudioChannels"] = "2";
    queryParam["RequireAvc"] = "false";
    // queryParam["Tag"] = "44db3569cff049d3039fab0ac7d83975";
    queryParam["SegmentContainer"] = "ts";
    queryParam["MinSegments"] = "1";
    queryParam["BreakOnNonKeyFrames"] = "true";
    queryParam["h264-profile"] = "high,main,baseline,constrainedbaseline";
    queryParam["h264-level"] = "51";
    queryParam["h264-deinterlace"] = "true";
    queryParam["TranscodeReasons"] = "VideoCodecNotSupported";

    final uri = new Uri.https(server.url.replaceAll('https://', ''),
        '/videos/${item.id}/main.m3u8', queryParam);
    String url = uri.toString();
    return url;
  }

  Future<void> setNewStream(String videoPath) {
    _controller = VideoPlayerController.network(videoPath);
    _controller.addListener(() {
      setState(() {
        _playBackTime = _controller.value.position.inSeconds;
      });
    });
    return _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.seekTo(newCurrentPosition);
      _controller.play();
    });
  }

  Future<bool> _clearPrevious() async {
    await _controller?.pause();
    return true;
  }

  Future<void> _initializePlay(String videoPath) async {
    _controller = VideoPlayerController.network(videoPath);
    _controller.addListener(() {
      setState(() {
        _playBackTime = _controller.value.position.inSeconds;
      });
    });
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.seekTo(newCurrentPosition);
      _controller.play();
    });
  }
}
