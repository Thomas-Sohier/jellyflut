import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/mediaStream.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:subtitle_wrapper_package/data/models/style/subtitle_position.dart';
import 'package:subtitle_wrapper_package/data/models/style/subtitle_style.dart';
import 'package:subtitle_wrapper_package/subtitle_controller.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
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
  static const platform =
      const MethodChannel('com.example.jellyflut/videoPlayer');
  Future<void> _initializeVideoPlayerFuture;
  int _playBackTime;
  int _subsId;
  Timer _timer;

  final SubtitleController subtitleController = SubtitleController(
      showSubtitles: true,
      subtitleUrl: server.url,
      subtitleDecoder: SubtitleDecoder.utf8,
      subtitleType: SubtitleType.srt);

  //The values that are passed when changing quality
  Duration newCurrentPosition;

  bool _visible = false;

  VideoPlayerController _controller;
  Item item = new Item();

  @override
  void initState() {
    // final Item media = ModalRoute.of(context).settings.arguments as Item;
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Wakelock.enable();
    autoHideControl();
    Future.delayed(Duration.zero, () {
      setState(() {
        Item tempItem = ModalRoute.of(context).settings.arguments as Item;
        getItem(tempItem.id).then((Item responseItem) {
          item = responseItem;
          _initializePlay(createURl(responseItem), platform);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
              child: Stack(children: [
            if (_controller != null && _controller.value.initialized)
              Center(
                  child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: SubTitleWrapper(
                          videoPlayerController: _controller,
                          subtitleController: subtitleController,
                          subtitleStyle: SubtitleStyle(
                            textColor: Colors.white,
                            fontSize: 18,
                            position: SubtitlePosition(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.05),
                            hasBorder: true,
                          ),
                          videoChild: GestureDetector(
                              onTap: () {
                                _visible = !_visible;
                                autoHideControl();
                              },
                              child: VideoPlayer(_controller)))))
            else
              Center(child: CircularProgressIndicator()),
            if (_controller != null && _playBackTime != null)
              Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Visibility(
                    child: videoControl(),
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _visible,
                  )),
          ])),
        ));
  }

  Widget videoControl() {
    return Row(children: [
      Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ))),
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
      Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: GestureDetector(
              onTap: () {
                changeSubtitle(item, context);
              },
              child: Icon(
                Icons.subtitles,
                color: Colors.white,
              ))),
      Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: GestureDetector(
              onTap: () {
                changeAudioSource(item, context);
              },
              child: Icon(
                Icons.library_music,
                color: Colors.white,
              ))),
    ]);
  }

  Future<void> autoHideControl() {
    Future.delayed(const Duration(seconds: 5), () {
      //asynchronous delay
      if (this.mounted) {
        //checks if widget is still active and not disposed
        setState(() {
          //tells the widget builder to rebuild again because ui has updated
          _visible =
              false; //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
        });
      }
    });
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
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  String createURl(Item item, {int startTick = 0}) {
    return "${server.url}/Videos/${item.id}/stream.${item.container.split(',').first}?startTimeTicks=${startTick}";
  }

  String createTranscodeUrl(Item item) {
    Map<String, String> queryParam = new Map();

    queryParam["MediaSourceId"] = item.id;
    queryParam["VideoCodec"] = "h264";
    queryParam["AudioCodec"] = "mp3,aac";
    queryParam["AudioStreamIndex:"] = "1";
    queryParam["VideoBitrate"] = "148288567";
    queryParam["AudioBitrate"] = "384000";
    queryParam["api_key"] = apiKey;
    queryParam["TranscodingMaxAudioChannels"] = "2";
    queryParam["RequireAvc"] = "false";
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

  Future<void> _initializePlay(String videoPath, MethodChannel platform) async {
    isCodecSupported(item, platform);
    _controller = VideoPlayerController.network(videoPath);
    _controller.initialize().then((_) {
      print("Stream controller initialized");
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {
        _controller.play();
      });
      _timer = Timer.periodic(
          Duration(seconds: 15),
          (Timer t) =>
              itemProgress(item, _controller, subtitlesIndex: _subsId));
      _controller.addListener(() {
        setState(() {
          _playBackTime = _controller.value.position.inSeconds;
        });
      });
    }).catchError((onError) {
      showToast("Can't direct play this file, trying to transcode...");
      setNewStream(createTranscodeUrl(item)).catchError((onError) {
        dispose();
        navigatorKey.currentState.pop();
      });
    });
  }

  void changeSubtitle(Item item, BuildContext context) {
    List<MediaStream> subtitles = item.mediaStreams
        .where((element) => element.type.toString() == "Type.SUBTITLE")
        .toList();
    if (subtitles != null && subtitles.length > 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Select Subtitle"),
              content: Container(
                width: double.maxFinite,
                height: 250,
                child: ListView.builder(
                  itemCount: subtitles.length + 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        index < subtitles.length
                            ? subtitles[index].displayTitle
                            : 'Disable',
                      ),
                      onTap: () {
                        setSubtitles(item.id, subtitles[index].codec.toString(),
                            subtitles[index].index);
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
      showToast("No subtitles found");
    }
  }

  Future<ClosedCaptionFile> setSubtitles(
      String itemId, String codec, int subtitleId) async {
    _subsId = subtitleId;
    String mediaSourceId = itemId.substring(0, 8) +
        "-" +
        itemId.substring(8, 12) +
        "-" +
        itemId.substring(12, 16) +
        "-" +
        itemId.substring(16, 20) +
        "-" +
        itemId.substring(20, itemId.length);

    String parsedCodec = codec.substring(codec.indexOf('.') + 1);

    Map<String, String> queryParam = new Map();
    queryParam["api_key"] = apiKey;

    final uri = new Uri.https(
        server.url.replaceAll('https://', ''),
        '/Videos/${mediaSourceId}/${itemId}/Subtitles/${subtitleId}/0/Stream.${parsedCodec}',
        queryParam);
    subtitleController.updateSubtitleUrl(url: uri.toString());
  }

  void changeAudioSource(Item item, BuildContext context) {
    List<MediaStream> subtitles = item.mediaStreams
        .where((element) => element.type.toString() == "Type.AUDIO")
        .toList();
    if (subtitles != null && subtitles.length > 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Select Subtitle"),
              content: Container(
                width: double.maxFinite,
                height: 250,
                child: ListView.builder(
                  itemCount: subtitles.length + 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        index < subtitles.length
                            ? subtitles[index].displayTitle
                            : 'Disable',
                      ),
                      onTap: () {
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
      showToast("No subtitles found");
    }
  }
}

Future<double> _bufferingPercentage(VideoPlayerController controller) async {
  if (controller.value.buffered.length == 0) return 0.0;
  final bufferedMilliseconds = controller.value.buffered
      .map((element) =>
          element.end.inMilliseconds - element.start.inMilliseconds)
      .toList()
      .reduce((a, b) => a + b);
  return bufferedMilliseconds / controller.value.duration.inMilliseconds * 100;
}

void isCodecSupported(Item item, MethodChannel platform) async {
  // TODO finish this method to know if video can be direct play
  if (Platform.isAndroid) {
    List<String> codecs = item.container.split(",");
    print(codecs);
    final dynamic result = await platform.invokeMethod('getListOfCodec');
    print(result);
  } else if (Platform.isIOS) {
    // TODO make IOS
  }
}
