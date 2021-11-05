import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_controls.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_headerBar.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_image.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_infos.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_playlist.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_colors.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_metadata.dart';
import 'package:jellyflut/shared/responsive_builder.dart';
import 'package:jellyflut/theme.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late MusicProvider musicProvider;
  late Color backgroundColor1;
  late Color backgroundColor2;
  late Color foregroundColor;
  late int musicPlayerIndex;

  @override
  void initState() {
    super.initState();
    backgroundColor1 = jellyLightPurple;
    backgroundColor2 = jellyDarkPurple;
    foregroundColor = Colors.white;
    musicProvider = MusicProvider();
    musicProvider
        .getCurrentMusicStream()
        .listen((SequenceState? sequenceState) {
      setAlbumPrimaryColor();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return player();
  }

  Widget player() {
    var statusBarHeight =
        MediaQuery.of(context).padding.top == 0 ? 12.toDouble() : 12.toDouble();
    var size = MediaQuery.of(context).size;
    var height = size.height - statusBarHeight;
    return Scaffold(
        extendBody: false,
        backgroundColor: Colors.grey.shade900,
        body: ResponsiveBuilder.builder(
            mobile: () => phoneTemplate(height, statusBarHeight),
            tablet: () => largeScreenTemplate(height, statusBarHeight),
            desktop: () => largeScreenTemplate(height, statusBarHeight)));
  }

  Widget largeScreenTemplate(double height, double statusBarHeight) {
    var singleSize = (height * 0.90 > 600 ? 600 : height * 0.90) * 0.6;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SongHeaderBar(height: height * 0.05, color: Colors.white),
      ),
      Expanded(
        child: Row(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: singleSize, child: SongInfos(color: Colors.white)),
                  SizedBox(
                    height: singleSize + 40,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        SongImage(
                            singleSize: singleSize,
                            color: foregroundColor,
                            albumColors: [backgroundColor1, backgroundColor2]),
                        Positioned.fill(
                            top: singleSize - 40,
                            child: SongControls(
                                color: foregroundColor,
                                backgroundColor: backgroundColor2)),
                      ],
                    ),
                  ),
                ]),
          )),
          Expanded(
            child: ClipRRect(
              child: Column(
                children: [
                  Expanded(
                    child: SongPlaylist(
                        backgroundColor: Colors.grey.shade900,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ]),
      )
    ]);
  }

  Widget phoneTemplate(double height, double statusBarHeight) {
    var singleSize = (height * 0.90 > 600 ? 600 : height * 0.90) * 0.6;
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: statusBarHeight,
            ),
            SongHeaderBar(height: height * 0.05, color: Colors.white),
            SizedBox(width: singleSize, child: SongInfos(color: Colors.white)),
            SizedBox(
              height: singleSize + 40,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SongImage(
                      singleSize: singleSize,
                      color: foregroundColor,
                      albumColors: [backgroundColor1, backgroundColor2]),
                  Positioned.fill(
                      top: singleSize - 40,
                      child: SongControls(
                          color: foregroundColor,
                          backgroundColor: backgroundColor2)),
                ],
              ),
            ),
          ],
        ));
  }

  void setAlbumPrimaryColor() {
    final currentMusic = musicProvider.getCurrentMusic();
    if (currentMusic != null) {
      final metadata = currentMusic.tag as AudioMetadata;
      PaletteGenerator.fromImageProvider(MemoryImage(metadata.artworkByte))
          .then((PaletteGenerator value) {
        final backgroundColor1 = value.paletteColors[0].color;
        final backgroundColor2 = value.paletteColors[1].color;
        final foregroundColor = getForegroundColorFromColor(backgroundColor1);
        final audioColors = AudioColors(
            backgroundColor1: backgroundColor1,
            backgroundColor2: backgroundColor2,
            foregroundColor: foregroundColor);
        musicProvider.setNewColors(audioColors);
      });
    }
  }

  Color getForegroundColorFromColor(Color color) {
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
