import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/musicPlayer/songBackground.dart';
import 'package:jellyflut/screens/musicPlayer/songControls.dart';
import 'package:jellyflut/screens/musicPlayer/songImage.dart';
import 'package:jellyflut/screens/musicPlayer/songInfos.dart';
import 'package:jellyflut/screens/musicPlayer/songPlaylist.dart';
import 'package:jellyflut/provider/musicPlayer.dart' as MusicPlayerProvider;
import 'package:jellyflut/shared/theme.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer({Key key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  MusicPlayerProvider.MusicPlayer musicPlayer;
  Color backgroundColor1;
  Color backgroundColor2;
  Color foregroundColor;
  int musicPlayerIndex;

  @override
  void initState() {
    super.initState();
    backgroundColor1 = jellyLightPurple.shade500;
    backgroundColor2 = jellyLightBLue.shade50;
    foregroundColor = Colors.black;
    musicPlayer = MusicPlayerProvider.MusicPlayer();
    musicPlayerIndex = musicPlayer.assetsAudioPlayer.current.value.index;
    setAlbumPrimaryColor();
    playerListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SongBackground(
              color1: backgroundColor1,
              color2: backgroundColor2,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SongImage(height: size.height * 0.45, color: foregroundColor),
                SongInfos(height: size.height * 0.15, color: foregroundColor),
                SongControls(
                    height: size.height * 0.10, color: foregroundColor),
                SongPlaylist(height: size.height * 0.30, color: foregroundColor)
              ],
            )
          ],
        ));
  }

  void setAlbumPrimaryColor() {
    var url = musicPlayer
        .assetsAudioPlayer.current.value.audio.audio.metas.image.path;
    PaletteGenerator.fromImageProvider(NetworkImage(url))
        .then((PaletteGenerator value) => setState(() => {
              setBackground(
                  value.paletteColors[0].color, value.paletteColors[1].color),
              setForegroundColorFromBackground()
            }));
  }

  void setBackground(Color color1, Color color2) {
    backgroundColor1 = color1;
    backgroundColor2 = color2;
  }

  void setForegroundColorFromBackground() {
    foregroundColor =
        backgroundColor1.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  void playerListener() {
    musicPlayer.assetsAudioPlayer.realtimePlayingInfos.listen((event) {
      if (musicPlayerIndex != event.current.index) {
        musicPlayerIndex = event.current.index;
        setAlbumPrimaryColor();
      }
    });
  }
}
