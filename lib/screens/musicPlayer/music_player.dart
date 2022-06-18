import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_controls.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_duration_position.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_image.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_infos.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_playlist.dart';
import 'package:jellyflut/screens/musicPlayer/components/song_playlist_card.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late MusicProvider musicProvider;
  late int musicPlayerIndex;
  late ThemeData theme;
  late final ValueNotifier<ThemeData?> themeData;

  @override
  void initState() {
    super.initState();
    themeData = ValueNotifier(null);
    musicProvider = MusicProvider();
    musicProvider.getCurrentMusicStream().listen((_) => setAlbumPrimaryColor());
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData?>(
        valueListenable: themeData,
        builder: (context, value, child) {
          return Scaffold(
            body: Theme(
                data: value ?? Theme.of(context),
                child: child ?? const SizedBox()),
          );
        },
        child: body());
  }

  Widget body() {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: songDetails(constraints)),
            if (constraints.maxWidth > 960)
              Expanded(child: SongPlaylistCard(child: SongPlaylist()))
          ]);
    });
  }

  Widget songDetails(BoxConstraints constraints) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppBar(
              backgroundColor: Colors.transparent,
              actions: [if (constraints.maxWidth < 960) playlistButton()]),
          const SizedBox(height: 10),
          SongInfos(),
          const SizedBox(height: 20),
          Expanded(child: LayoutBuilder(builder: (context, constraints) {
            final singleSize = calculateSingleSize(constraints);
            return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: singleSize),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SongDurationPosition(),
                    Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          SongImage(),
                          Positioned(bottom: -30, child: SongControls())
                        ]),
                  ],
                ));
          })),
        ]);
  }

  double calculateSingleSize(BoxConstraints constraints) {
    final smallestSide = min(constraints.maxWidth, constraints.maxHeight);
    return (smallestSide * 0.90 > 600 ? 600 : smallestSide * 0.90) * 0.9;
  }

  Widget playlistButton() {
    return IconButton(
        onPressed: () => customRouter.push(PlaylistRoute(body: SongPlaylist())),
        icon: Icon(Icons.album));
  }

  void setAlbumPrimaryColor() {
    final currentMusic = musicProvider.getCurrentMusic();
    if (currentMusic != null && mounted) {
      final metadata = currentMusic.metadata;
      compute(ColorUtil.extractPixelsColors, metadata.artworkByte)
          .then((List<Color> colors) {
        final brightness = Theme.of(context).brightness;
        themeData.value = personnal_theme.Theme.generateThemeDataFromSeedColor(
            brightness, colors[0]);
      });
    }
  }

  Color getForegroundColorFromColor(Color color) {
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
