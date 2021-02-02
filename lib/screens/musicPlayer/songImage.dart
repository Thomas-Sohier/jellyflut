import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/infiniteAnimation.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/musicPlayer/songControls.dart';

class SongImage extends StatefulWidget {
  final double height;
  final Color color;
  final List<Color> albumColors;

  SongImage(
      {Key key,
      @required this.height,
      @required this.color,
      @required this.albumColors})
      : super(key: key);

  @override
  _SongImageState createState() => _SongImageState();
}

class _SongImageState extends State<SongImage> {
  MusicPlayer musicPlayer;
  int _playBackTime;
  double posx = 100.0;
  double posy = 100.0;

  @override
  void initState() {
    super.initState();
    musicPlayer = MusicPlayer();
    _playBackTime = musicPlayer.assetsAudioPlayer?.current?.value?.audio
            ?.duration?.inMilliseconds ??
        0;
    playerListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = widget.height > 600 ? 600 : widget.height;
    var singleSize = height * 0.8;
    return Container(
        height: height,
        width: double.maxFinite,
        child: imageSingle(singleSize));
  }

  BackdropFilter defaultSingleStyle(double size) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, spreadRadius: 8, color: Colors.black54)
                ],
                color: Colors.grey.shade200.withOpacity(0.5),
                shape: BoxShape.circle)));
  }

  Widget imageSingle(double size) {
    var sliderSize =
        size * (_playBackTime / musicPlayer.currentMusicMaxDuration());
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: GestureDetector(
                onTapDown: (TapDownDetails details) =>
                    onTapDown(context, details, size),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(musicPlayer.assetsAudioPlayer
                                .current.value.audio.audio.metas.image.path)),
                      ),
                    ),
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              color: widget.albumColors[1].withAlpha(150),
                              width: sliderSize,
                            ))),
                  ],
                ))),
        Positioned.fill(
            top: size - 30,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: SongControls(
                    color: widget.color,
                    backgroundColor: widget.albumColors[1])))
      ],
    );
  }

  void playerListener() {
    musicPlayer.assetsAudioPlayer.realtimePlayingInfos.listen((event) {
      if (event.isPlaying && mounted) {
        setState(() {
          _playBackTime = event.currentPosition.inMilliseconds.toInt();
        });
      }
    });
  }

  void onTapDown(
      BuildContext context, TapDownDetails details, double widgetWidth) {
    print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final localOffset = box.globalToLocal(details.globalPosition);
    posx = localOffset.dx;
    var percentWidth = posx / widgetWidth;
    var duration = musicPlayer.currentMusicMaxDuration() * percentWidth;
    musicPlayer.assetsAudioPlayer
        .seek(Duration(milliseconds: duration.toInt()));
  }
}
