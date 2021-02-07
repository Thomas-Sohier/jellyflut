import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/streamingSoftware.dart';
import 'package:jellyflut/screens/stream/streamBP.dart';
import 'package:jellyflut/screens/stream/streamVLC.dart';

VlcPlayerController _controller;

void automaticStreamingSoftwareChooser(
    {@required String url,
    @required Item item,
    @required BuildContext context}) async {
  var streamingSoftware = StreamingSoftware(name: StreamingSoftwareName.vlc);
  switch (streamingSoftware.name) {
    case StreamingSoftwareName.vlc:
      _controller = VlcPlayerController.network(
        url,
        hwAcc: HwAcc.FULL,
        onInit: () async {
          await _controller.startRendererScanning();
        },
        onRendererHandler: (type, id, name) {
          print('onRendererHandler $type $id $name');
        },
        options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(2000),
          ]),
          rtp: VlcRtpOptions([
            VlcRtpOptions.rtpOverRtsp(true),
          ]),
        ),
      );
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  StreamVLC(controller: _controller, showControls: true)));
      break;
    case StreamingSoftwareName.exoplayer:
      Stream(
        streamUrl: url,
        playbackInfos: null,
        item: item,
      );
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Stream(item: item, streamUrl: url, playbackInfos: null)));
      break;
  }
}
