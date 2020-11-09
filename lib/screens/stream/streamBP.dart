import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/models/item.dart';

import '../../globals.dart';

class Stream extends StatefulWidget {
  final Item item;
  final String streamUrl;

  const Stream({@required this.item, @required this.streamUrl});

  @override
  _StreamState createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  var dataSource;

  Future<BetterPlayerDataSource> setupData() async {
    dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.NETWORK, widget.streamUrl,
        subtitles: await getSubtitles(widget.item));

    return dataSource;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<BetterPlayerDataSource>(
        future: setupData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
              child: AspectRatio(
                child: BetterPlayerPlaylist(
                  betterPlayerConfiguration: BetterPlayerConfiguration(
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      fit: BoxFit.contain,
                      subtitlesConfiguration:
                          BetterPlayerSubtitlesConfiguration(fontSize: 18),
                      controlsConfiguration:
                          BetterPlayerControlsConfiguration.cupertino(),
                      deviceOrientationsAfterFullScreen: [
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                      ]),
                  betterPlayerPlaylistConfiguration:
                      BetterPlayerPlaylistConfiguration(
                          loopVideos: false,
                          nextVideoDelay: Duration(seconds: 5)),
                  betterPlayerDataSourceList: [dataSource],
                ),
                aspectRatio: 16 / 9,
              ),
            );
          }
        },
      ),
    );
  }
}

Future<List<BetterPlayerSubtitlesSource>> getSubtitles(Item item) async {
  var subtitles = item.mediaStreams
      .where((element) => element.type.toString() == 'Type.SUBTITLE')
      .toList();
  var asyncSubs = subtitles
      .map((sub) async => BetterPlayerSubtitlesSource(
          type: BetterPlayerSubtitlesSourceType.NETWORK,
          urls: [
            await getSubtitleURL(item.id, sub.codec.toString(), sub.index)
          ],
          name: sub.title))
      .toList();
  return Future.wait(asyncSubs);
}

Future<String> getSubtitleURL(
    String itemId, String codec, int subtitleId) async {
  var mediaSourceId = itemId.substring(0, 8) +
      '-' +
      itemId.substring(8, 12) +
      '-' +
      itemId.substring(12, 16) +
      '-' +
      itemId.substring(16, 20) +
      '-' +
      itemId.substring(20, itemId.length);

  var parsedCodec = codec.substring(codec.indexOf('.') + 1);

  var queryParam = <String, String>{};
  queryParam['api_key'] = apiKey;

  var uri = Uri.https(
      server.url.replaceAll('https://', ''),
      '/Videos/${mediaSourceId}/${itemId}/Subtitles/${subtitleId}/0/Stream.${parsedCodec}',
      queryParam);
  return uri.origin + uri.path;
}
