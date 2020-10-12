import 'package:flutter/services.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/mediaStream.dart';
import 'package:jellyflut/shared/shared.dart';
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
  Future<void> _initializeVideoPlayerFuture;
  int _playBackTime;

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
    Future.delayed(Duration.zero, () {
      setState(() {
        Item tempItem = ModalRoute.of(context).settings.arguments as Item;
        getItem(tempItem.id).then((Item responseItem) {
          item = responseItem;
          _initializePlay(createURl(responseItem));
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
            if (_controller != null)
              _controller.value.initialized
                  ? Center(
                      child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: SubTitleWrapper(
                              videoPlayerController: _controller,
                              subtitleController: subtitleController,
                              subtitleStyle: SubtitleStyle(
                                textColor: Colors.white,
                                hasBorder: true,
                              ),
                              videoChild: VideoPlayer(_controller))))
                  : Center(child: CircularProgressIndicator()),
            if (_controller != null)
              Visibility(
                child: videoControl(),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _visible,
              ),
          ])),
        ));
  }

  Widget videoControl() {
    return Row(children: [
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
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
      Expanded(
          flex: 1,
          child: GestureDetector(
              onTap: () {
                changeSubtitle(item, context);
              },
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
    ]);
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

  Future<void> _initializePlay(String videoPath) async {
    _controller = VideoPlayerController.network(videoPath)
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
