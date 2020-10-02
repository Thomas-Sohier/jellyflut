import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/models/itemDetails.dart';

import '../../globals.dart';

class StreamVLC extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StreamVLCState();
}

class _StreamVLCState extends State<StreamVLC> {
  bool _visible = true;
  Uint8List image;
  VlcPlayerController _videoViewController;
  bool isPlaying = true;
  double sliderValue = 0.0;
  double currentPlayerTime = 0;
  double volumeValue = 100;
  String position = "";
  String duration = "";
  int numberOfCaptions = 0;
  int numberOfAudioTracks = 0;
  bool isBuffering = true;
  bool getCastDeviceBtnEnabled = false;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _videoViewController = new VlcPlayerController(onInit: () {
      _videoViewController.play();
    });
    _videoViewController.addListener(() {
      if (!this.mounted) return;
      if (_videoViewController.initialized) {
        var oPosition = _videoViewController.position;
        var oDuration = _videoViewController.duration;
        if (oDuration.inHours == 0) {
          var strPosition = oPosition.toString().split('.')[0];
          var strDuration = oDuration.toString().split('.')[0];
          position =
              "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
          duration =
              "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
        } else {
          position = oPosition.toString().split('.')[0];
          duration = oDuration.toString().split('.')[0];
        }
        sliderValue = _videoViewController.position.inSeconds.toDouble();
        numberOfCaptions = _videoViewController.spuTracksCount;
        numberOfAudioTracks = _videoViewController.audioTracksCount;

        switch (_videoViewController.playingState) {
          case PlayingState.PAUSED:
            setState(() {
              isBuffering = false;
            });
            break;

          case PlayingState.STOPPED:
            setState(() {
              isPlaying = false;
              isBuffering = false;
            });
            break;
          case PlayingState.BUFFERING:
            setState(() {
              isBuffering = true;
            });
            break;
          case PlayingState.PLAYING:
            setState(() {
              isBuffering = false;
            });
            break;
          case PlayingState.ERROR:
            setState(() {});
            print("VLC encountered error");
            break;
          default:
            setState(() {});
            break;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ItemDetail media =
        ModalRoute.of(context).settings.arguments as ItemDetail;
    return Scaffold(
        body: GestureDetector(
            onTap: () => {_toggleMenu()},
            child: Container(
                color: Colors.black,
                height: 250.0,
                child: Stack(children: <Widget>[
                  VlcPlayer(
                    aspectRatio: 16 / 9,
                    url: createURl(media),
                    isLocalMedia: false,
                    controller: _videoViewController,
                    // Play with vlc options
                    options: [
                      '--quiet',
//                '-vvv',
                      '--no-drop-late-frames',
                      '--no-skip-frames',
                      '--rtsp-tcp',
                    ],
                    hwAcc: HwAcc.AUTO,
                    // or {HwAcc.AUTO, HwAcc.DECODING, HwAcc.FULL}
                    placeholder: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[CircularProgressIndicator()],
                      ),
                    ),
                  ),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _visible,
                    child: _vlcPlayerControl(media),
                  ),
                ]))));
  }

  @override
  void dispose() {
    _videoViewController.dispose();
    super.dispose();
  }

  Widget _vlcPlayerControl(ItemDetail media) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 1,
          child: new IconButton(
            icon: isPlaying
                ? Icon(
                    Icons.pause_circle_outline,
                    color: Colors.white,
                  )
                : Icon(Icons.play_circle_outline, color: Colors.white),
            highlightColor: Colors.blueAccent,
            onPressed: () => {playOrPauseVideo()},
          ),
        ),
        Flexible(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                position,
                style: TextStyle(color: Colors.white),
              ),
              Expanded(
                child: Slider(
                  activeColor: Colors.blue,
                  value: sliderValue,
                  min: 0.0,
                  max: _videoViewController.duration == null
                      ? 1.0
                      : _videoViewController.duration.inSeconds.toDouble(),
                  onChanged: (progress) {
                    setState(() {
                      sliderValue = progress.floor().toDouble();
                      _videoViewController.setStreamUrl(createURl(media));
                    });
                    //convert to Milliseconds since VLC requires MS to set time
                    _videoViewController.setTime(sliderValue.toInt() * 1000);
                  },
                ),
              ),
              Text(duration, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: new IconButton(
              icon: new Icon(Icons.subtitles, color: Colors.white),
              highlightColor: Colors.blueAccent,
              onPressed: () => {_getSubtitleTracks()}),
        ),
        Flexible(
          flex: 1,
          child: new IconButton(
            icon: new Icon(Icons.audiotrack, color: Colors.white),
            highlightColor: Colors.blueAccent,
            onPressed: () => {_getAudioTracks()},
          ),
        )
      ],
    );
  }

  void playOrPauseVideo() {
    String state = _videoViewController.playingState.toString();

    if (state == "PlayingState.PLAYING") {
      _videoViewController.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      _videoViewController.play();
      setState(() {
        isPlaying = true;
      });
    }
  }

  void _getSubtitleTracks() async {
    if (_videoViewController.playingState.toString() != "PlayingState.PLAYING")
      return;

    Map<dynamic, dynamic> subtitleTracks =
        await _videoViewController.getSpuTracks();
    //
    if (subtitleTracks != null && subtitleTracks.length > 0) {
      int selectedSubId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Subtitle"),
            content: Container(
              width: double.maxFinite,
              height: 250,
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
      if (selectedSubId != null)
        await _videoViewController.setSpuTrack(selectedSubId);
    }
  }

  void _getAudioTracks() async {
    if (_videoViewController.playingState.toString() != "PlayingState.PLAYING")
      return;

    Map<dynamic, dynamic> audioTracks =
        await _videoViewController.getAudioTracks();
    //
    if (audioTracks != null && audioTracks.length > 0) {
      int selectedAudioTrackId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Audio"),
            content: Container(
              width: double.maxFinite,
              height: 250,
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
      if (selectedAudioTrackId != null)
        await _videoViewController.setAudioTrack(selectedAudioTrackId);
    }
  }

  void _getCastDevices() async {
    Map<dynamic, dynamic> castDevices =
        await _videoViewController.getCastDevices();
    //
    if (castDevices != null && castDevices.length > 0) {
      String selectedCastDeviceName = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Cast Device"),
            content: Container(
              width: double.maxFinite,
              height: 250,
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
      await _videoViewController.startCasting(
        selectedCastDeviceName,
      );
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("No Cast Device Found!")));
    }
  }

  void _toggleMenu() {
    _visible = !_visible;
    if (_visible) _autoHide();
  }

  void _autoHide() {
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
}

String createURl(ItemDetail item, {double startTick = 0}) {
  String url =
      "${basePath}/Videos/${item.id}/stream.${item.container.split(',').first}?startTimeTicks=${startTick}";
  return url;
}
