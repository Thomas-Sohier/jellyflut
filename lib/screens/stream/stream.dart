import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/itemDetails.dart';
import 'package:jellyflut/models/media.dart';

import '../../globals.dart';

class Stream extends StatefulWidget {
  @override
  _StreamState createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final ItemDetail media =
        ModalRoute.of(context).settings.arguments as ItemDetail;
    // String url = "${basePath}/Videos/${media.id}/stream.mkv";
    var dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.NETWORK,
      createURl(media),
    );

    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
            controlsConfiguration:
                BetterPlayerControlsConfiguration(enableProgressText: true),
            fullScreenByDefault: true,
            aspectRatio: 16 / 9,
            fit: BoxFit.contain),
        betterPlayerDataSource: dataSource);
    return Container(
        height: size.height,
        width: size.width,
        child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildFileVideo(),
                ])));
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  Widget _buildFileVideo() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(controller: _betterPlayerController),
    );
  }
}

String createURl(ItemDetail item) {
  String url =
      "${basePath}/Videos/${item.id}/stream.${item.container.split(',').first}";
  return url;
}

BetterPlayerDataSource getNewDataSource(String url) {
  return BetterPlayerDataSource(
    BetterPlayerDataSourceType.NETWORK,
    url,
  );
}
