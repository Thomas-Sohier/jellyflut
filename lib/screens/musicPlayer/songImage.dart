import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/musicPlayer/songControls.dart';
import 'package:jellyflut/screens/musicPlayer/songSlider.dart';
import 'package:octo_image/octo_image.dart';

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
  double posx = 100.0;
  double posy = 100.0;

  @override
  void initState() {
    super.initState();
    musicPlayer = MusicPlayer();
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
        child: imageSingleAsync(singleSize));
  }

  Widget imageSingleAsync(double size) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.hardEdge,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: SizedBox(
                width: size,
                height: size,
                child: LayoutBuilder(
                  builder: (singleContext, constraints) => GestureDetector(
                    onTapDown: (TapDownDetails details) =>
                        onTapDown(singleContext, details),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        musicPlayer.getCurrentAudioImagePath() != null
                            ? OctoImage(
                                image: CachedNetworkImageProvider(
                                    musicPlayer.getCurrentAudioImagePath()),
                                placeholderBuilder: (_) => placeholder(size),
                                errorBuilder: (context, error, e) =>
                                    placeholder(size),
                                fadeInDuration: Duration(milliseconds: 300),
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                width: size,
                                height: size,
                              )
                            : placeholder(size),
                        Positioned.fill(
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: SongSlider(
                                  albumColors: widget.albumColors,
                                ))),
                      ],
                    ),
                  ),
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

  Widget placeholder(double size) {
    return Container(
        height: size,
        color: widget.albumColors[0],
        child: Center(
          child: Icon(
            Icons.album,
            color: widget.color,
            size: 70,
          ),
        ));
  }

  Widget finalImage(ImageProvider<Object> imageProvider, double size) {
    return Container(
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider,
          ),
        ));
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    final widgetWidth = context.size.width;
    final RenderBox box = context.findRenderObject();
    final localOffset = box.globalToLocal(details.globalPosition);
    posx = localOffset.dx;
    var percentWidth = posx / widgetWidth;
    var duration = musicPlayer.currentMusicMaxDuration() * percentWidth;
    if (duration > 0 && duration < musicPlayer.currentMusicMaxDuration()) {
      musicPlayer.assetsAudioPlayer
          .seek(Duration(milliseconds: duration.toInt()));
    }
  }
}
