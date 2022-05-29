import 'package:flutter/material.dart';

import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_slider.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_metadata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:octo_image/octo_image.dart';

class SongImage extends StatefulWidget {
  final double singleSize;
  final Color color;
  final List<Color> albumColors;

  SongImage(
      {super.key,
      required this.singleSize,
      required this.color,
      required this.albumColors});

  @override
  _SongImageState createState() => _SongImageState();
}

class _SongImageState extends State<SongImage> {
  late MusicProvider musicProvider;
  double posx = 100.0;
  double posy = 100.0;

  @override
  void initState() {
    super.initState();
    musicProvider = MusicProvider();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: double.maxFinite, child: imageSingleAsync());
  }

  Widget imageSingleAsync() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: SizedBox(
              width: widget.singleSize,
              height: widget.singleSize,
              child: StreamBuilder<SequenceState?>(
                  stream: musicProvider.getCurrentMusicStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return albumImage(widget.singleSize);
                    }
                    return placeholder(widget.singleSize);
                  })),
        ),
      ],
    );
  }

  Widget albumImage(double singleSize) {
    return Stack(children: [
      LayoutBuilder(
        builder: (singleContext, constraints) => GestureDetector(
            onTapDown: (TapDownDetails details) =>
                onTapDown(singleContext, details),
            child: Stack(
              alignment: Alignment.center,
              children: [
                musicProvider.getCurrentMusic() != null
                    ? imageFromByte(singleSize)
                    : placeholder(singleSize),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: SongSlider(
                          albumColors: widget.albumColors,
                        ))),
              ],
            )),
      )
    ]);
  }

  OctoImage imageFromByte(double singleSize) {
    final currentMusic = musicProvider.getCurrentMusic();
    final metadata = currentMusic!.tag as AudioMetadata;
    return OctoImage(
      image: MemoryImage(metadata.artworkByte),
      placeholderBuilder: (_) => placeholder(singleSize),
      errorBuilder: (context, error, e) => placeholder(singleSize),
      fadeInDuration: Duration(milliseconds: 300),
      fit: BoxFit.cover,
      gaplessPlayback: true,
      alignment: Alignment.center,
      width: singleSize,
      height: singleSize,
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
    final widgetWidth = context.size?.width;
    final box = context.findRenderObject() as RenderBox;
    final localOffset = box.globalToLocal(details.globalPosition);
    posx = localOffset.dx;
    var percentWidth = posx / widgetWidth!;
    var duration = musicProvider.getDuration() * percentWidth;
    if (duration.inMilliseconds > 0 && duration < musicProvider.getDuration()) {
      musicProvider.seekTo(duration);
    }
  }
}
