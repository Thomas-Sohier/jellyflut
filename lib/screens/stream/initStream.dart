import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/streamingSoftware.dart';
import 'package:jellyflut/screens/stream/streamBP.dart';
import 'package:jellyflut/screens/stream/streamVLC.dart';

VlcPlayerController _controller;

void automaticStreamingSoftwareChooser(
    {@required Item item, @required BuildContext context}) async {
  var streamingSoftwareDB =
      await DatabaseService().getSettings(userDB.settingsId);
  var streamingSoftware = StreamingSoftwareName.values.firstWhere((e) =>
      e.toString() ==
      'StreamingSoftwareName.' + streamingSoftwareDB.preferredPlayer);
  switch (streamingSoftware) {
    case StreamingSoftwareName.vlc:
      var url = await item.getItemURL(directPlay: true);
      var _controller = initVlcController(url, item);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  StreamVLC(controller: _controller, showControls: true)));
      break;
    case StreamingSoftwareName.exoplayer:
      var url = await item.getItemURL();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Stream(item: item, streamUrl: url)));
      break;
  }
}

VlcPlayerController initVlcController(String url, Item item) {
  return VlcPlayerController.network(
    url,
    autoPlay: true,
    onInit: () async {
      await _controller.startRendererScanning();
    },
    options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        extras: [
          '--start-time=${Duration(microseconds: item.getPlaybackPosition()).inSeconds}' // Start at x seconds
        ]),
  );
}
