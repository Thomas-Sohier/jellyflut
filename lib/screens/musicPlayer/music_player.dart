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
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut/theme.dart' as personnal_theme;

import '../../shared/responsive_builder.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
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
    return ValueListenableBuilder<ThemeData?>(
      valueListenable: themeData,
      builder: (context, value, child) {
        return Theme(
            data: value ?? Theme.of(context), child: child ?? const SizedBox());
      },
      child: Scaffold(
          extendBody: false,
          body: ResponsiveBuilder.builder(
              mobile: () => phoneTemplate(height, statusBarHeight),
              tablet: () => largeScreenTemplate(height, statusBarHeight),
              desktop: () => largeScreenTemplate(height, statusBarHeight))),
    );
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
          child: Padding(
        padding: EdgeInsets.fromLTRB(12, 18, 18, 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: ColorUtil.darken(Theme.of(context).colorScheme.background),
              borderRadius: const BorderRadius.all(Radius.circular(14)),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).shadowColor.withAlpha(150),
                    blurRadius: 6,
                    spreadRadius: 2)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('playlist'.tr(),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headline5),
              ),
              Expanded(child: SongPlaylist())
            ],
          ),
        ),
      )),
    ]);
  }

  Widget songDetails(final double singleSize) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: singleSize, child: SongInfos()),
          SizedBox(
            height: singleSize + 40,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SongImage(singleSize: singleSize),
                Positioned.fill(top: singleSize - 40, child: SongControls()),
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
