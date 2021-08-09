import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/musicPlayer/components/songBackground.dart';
import 'package:jellyflut/screens/musicPlayer/components/songHeaderBar.dart';
import 'package:jellyflut/screens/musicPlayer/components/songImage.dart';
import 'package:jellyflut/provider/musicPlayer.dart' as music_player_provider;
import 'package:jellyflut/shared/theme.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late music_player_provider.MusicPlayer musicPlayer;
  late Color backgroundColor1;
  late Color backgroundColor2;
  late Color foregroundColor;
  late int musicPlayerIndex;

  @override
  void initState() {
    super.initState();
    backgroundColor1 = jellyLightPurple;
    backgroundColor2 = jellyDarkPurple;
    foregroundColor = Colors.black;
    musicPlayer = music_player_provider.MusicPlayer();
    musicPlayer.getCommonPlayer!
        .listenPlayingindex()
        .listen((event) => setState(() {
              musicPlayer.setPlayingIndex(event);
            }));
    // musicPlayerIndex = musicPlayer.assetsAudioPlayer.current.value!.index;
    setAlbumPrimaryColor();
    setForegroundColorFromBackground();
    // playerListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<music_player_provider.MusicPlayer>(
        builder: (context, mp, child) {
      return player();
    });
  }

  Widget player() {
    var statusBarHeight =
        MediaQuery.of(context).padding.top == 0 ? 12.toDouble() : 12.toDouble();
    var size = MediaQuery.of(context).size;
    var height = size.height - statusBarHeight;
    return Scaffold(
        extendBody: false,
        backgroundColor: Colors.grey[900],
        body: ChangeNotifierProvider.value(
            value: musicPlayer,
            child: Stack(
              children: [
                SongBackground(color: Colors.grey[900]!),
                Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: statusBarHeight,
                        ),
                        SongHeaderBar(
                            height: height * 0.05, color: Colors.white),
                        // SongInfos(height: height * 0.30, color: Colors.white),
                        SongImage(
                            height: height * 0.90,
                            color: foregroundColor,
                            albumColors: [backgroundColor1, backgroundColor2]),
                      ],
                    ))
              ],
            )));
  }

  void setAlbumPrimaryColor() {
    final image = musicPlayer.getCurrentMusic?.image;
    if (image != null) {
      PaletteGenerator.fromImageProvider(MemoryImage(image))
          .then((PaletteGenerator value) => setState(() => {
                setBackground(
                    value.paletteColors[0].color, value.paletteColors[1].color),
                setForegroundColorFromBackground()
              }));
    }
  }

  void setBackground(Color color1, Color color2) {
    backgroundColor1 = color1;
    backgroundColor2 = color2;
  }

  void setForegroundColorFromBackground() {
    foregroundColor =
        backgroundColor1.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  // void playerListener() {
  //   musicPlayer.assetsAudioPlayer.realtimePlayingInfos.listen((event) {
  //     if (event.current != null && musicPlayerIndex != event.current?.index) {
  //       musicPlayerIndex = event.current!.index;
  //       setAlbumPrimaryColor();
  //     }
  //   });
  // }
}
