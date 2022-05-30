import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_controls.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_image.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_infos.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_playlist.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_colors.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_metadata.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:just_audio/just_audio.dart';

import '../../shared/responsive_builder.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
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
    musicProvider = MusicProvider();
    musicProvider
        .getCurrentMusicStream()
        .listen((SequenceState? sequenceState) {
      setAlbumPrimaryColor();
    });
  }

  @override
  void didChangeDependencies() {
    backgroundColor1 = Theme.of(context).colorScheme.primary;
    backgroundColor2 = Theme.of(context).colorScheme.secondary;
    foregroundColor = Theme.of(context).colorScheme.onPrimary;
    super.didChangeDependencies();
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
        body: ResponsiveBuilder.builder(
            mobile: () => phoneTemplate(height, statusBarHeight),
            tablet: () => largeScreenTemplate(height, statusBarHeight),
            desktop: () => largeScreenTemplate(height, statusBarHeight)));
  }

  Widget largeScreenTemplate(double height, double statusBarHeight) {
    var singleSize = (height * 0.90 > 600 ? 600 : height * 0.90) * 0.6;
    return Row(children: [
      Expanded(
          child: Column(children: [
        AppBar(elevation: 0),
        Padding(
            padding: const EdgeInsets.all(16), child: songDetails(singleSize))
      ])),
      Expanded(
          child: Card(
        margin: EdgeInsets.all(12),
        color: ColorUtil.darken(Theme.of(context).cardTheme.color!, 0.05),
        child: ClipRect(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('playlist'.tr(),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline5),
            )),
            Expanded(child: SongPlaylist())
          ],
        )),
      )),
    ]);
  }

  Widget songDetails(final double singleSize) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
        ]);
  }

  Widget phoneTemplate(double height, double statusBarHeight) {
    var singleSize = (height * 0.90 > 600 ? 600 : height * 0.90) * 0.6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppBar(
          elevation: 0,
          actions: [playlistButton()],
        ),
        Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: songDetails(singleSize))
      ],
    );
  }

  Widget playlistButton() {
    return IconButton(
        onPressed: () => customRouter.push(PlaylistRoute(body: SongPlaylist())),
        icon: Icon(Icons.album, color: Theme.of(context).colorScheme.primary));
  }

  void setAlbumPrimaryColor() {
    final currentMusic = musicProvider.getCurrentMusic();
    if (currentMusic != null) {
      final metadata = currentMusic.tag as AudioMetadata;
      compute(ColorUtil.extractPixelsColors, metadata.artworkByte)
          .then((List<Color> colors) {
        final backgroundColor1 = colors[0];
        final backgroundColor2 = colors[1];
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
