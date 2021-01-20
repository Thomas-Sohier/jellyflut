import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/musicPlayer/songControls.dart';
import 'package:jellyflut/screens/musicPlayer/songImage.dart';
import 'package:jellyflut/screens/musicPlayer/songInfos.dart';
import 'package:jellyflut/screens/musicPlayer/songPlaylist.dart';
import 'package:jellyflut/provider/musicPlayer.dart' as MusicPlayerProvider;
import 'package:provider/provider.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer({Key key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  MusicPlayerProvider.MusicPlayer musicPlayer;

  @override
  void initState() {
    super.initState();
    musicPlayer = MusicPlayerProvider.MusicPlayer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.orange[600],
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SongImage(height: size.height * 0.45),
            SongInfos(height: size.height * 0.08),
            SongControls(height: size.height * 0.12),
            // Divider(),
            SongPlaylist(height: size.height * 0.35)
          ],
        ));
  }
}
