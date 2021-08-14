import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart' as vlc;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamVLC.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamVLCComputer.dart';
import 'package:jellyflut/screens/stream/components/commonControls.dart';
import 'package:jellyflut/screens/stream/stream.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// TODO rework with button to stream from url via stream class
// Not optimized right now
class TrailerButton extends StatelessWidget {
  final Item item;

  const TrailerButton({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton('Trailer', () => playTrailer(context),
        minWidth: 40,
        maxWidth: 150,
        borderRadius: 4,
        icon: Icon(Icons.movie, color: Colors.black87));
  }

  void playTrailer(BuildContext context) async {
    final youtubeUrl = item.getTrailer();
    final itemURi = Uri.parse(youtubeUrl);
    final videoId = itemURi.queryParameters['v'];
    final url = await getYoutubeUrl(videoId!);

    var playerWidget;
    if (Platform.isLinux || Platform.isWindows) {
      playerWidget = await _initVlcComputerPlayer(url.toString());
    } else {
      playerWidget = await _initVlcPhonePlayer(url.toString());
    }

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Stream(player: playerWidget, item: item)));
  }

  Future<Widget> _initVlcComputerPlayer(String url) async {
    final player = await CommonStreamVLCComputer.setupDataFromUrl(url: url);
    final streamModel = StreamModel();
    streamModel.setItem(item);
    streamModel.setIsDirectPlay(true);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        vlc.Video(
          playerId: player.id,
          height: player.videoHeight.toDouble(),
          width: player.videoWidth.toDouble(),
        ),
        CommonControls(isComputer: true),
      ],
    );
  }

  Future<Widget> _initVlcPhonePlayer(String url) async {
    final vlcPlayerController =
        await CommonStreamVLC.setupDataFromUrl(url: url);

    vlcPlayerController.addOnInitListener(() async {
      await vlcPlayerController.startRendererScanning();
    });

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: <Widget>[
        VlcPlayer(
          controller: vlcPlayerController,
          aspectRatio: item.getAspectRatio(),
          placeholder: Center(child: CircularProgressIndicator()),
        ),
        CommonControls(),
      ],
    );
  }

  Future<Uri> getYoutubeUrl(String videoId) async {
    var yt = YoutubeExplode();
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var streamInfo = manifest.muxed.withHighestBitrate();
    yt.close();
    return streamInfo.url;
  }
}
