import 'package:flutter/material.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_slider.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_source.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:octo_image/octo_image.dart';

class SongImage extends StatefulWidget {
  final double singleSize;

  SongImage({Key? key, required this.singleSize}) : super(key: key);

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
              child: StreamBuilder<AudioSource>(
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
                imageFromByte(singleSize),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.centerLeft, child: SongSlider())),
              ],
            )),
      )
    ]);
  }

  OctoImage imageFromByte(double singleSize) {
    final currentMusic = musicProvider.getCurrentMusic();
    final metadata = currentMusic!.metadata;
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
    final backgroundColor =
        ColorUtil.darken(Theme.of(context).colorScheme.background);
    final iconColor =
        ColorUtil.darken(Theme.of(context).colorScheme.onBackground);
    return Container(
        height: size,
        color: backgroundColor,
        child: Center(
          child: Icon(
            Icons.album,
            color: iconColor,
            size: 70,
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
