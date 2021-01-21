import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/infiniteAnimation.dart';
import 'package:jellyflut/provider/musicPlayer.dart';

class SongImage extends StatefulWidget {
  final double height;
  final Color color;
  SongImage({Key key, @required this.height, @required this.color})
      : super(key: key);

  @override
  _SongImageState createState() => _SongImageState();
}

class _SongImageState extends State<SongImage> {
  MusicPlayer musicPlayer;

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
    var height = widget.height;
    var singleSize = height * 0.8;
    return Container(
      height: height > 600 ? 600 : height,
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InfiniteAnimation(
              durationInSeconds: 60,
              child: Image.network(
                  musicPlayer.assetsAudioPlayer.current.value.audio.audio.metas
                      .image.path,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) =>
                          AnimatedOpacity(
                              opacity: frame == null ? 0 : 1,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeOut,
                              child: imageSingle(singleSize, child)),
                  errorBuilder: (context, error, stackTrace) =>
                      defaultSingleStyle(singleSize)))
        ],
      ),
    );
  }
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

Container imageSingle(double size, Widget image) {
  return Container(
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.indigo[200],
        boxShadow: [
          BoxShadow(blurRadius: 10, spreadRadius: 8, color: Colors.black54)
        ]),
    height: size,
    width: size,
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(size * 0.5)),
        child: image),
  );
}
