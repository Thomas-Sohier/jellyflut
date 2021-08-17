import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart' as vlc;
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamVLC.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamVLCComputer.dart';
import 'package:jellyflut/screens/stream/components/commonControls.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class TrailerButton extends StatefulWidget {
  final Item item;
  final EdgeInsetsGeometry padding;
  final double size;
  final Color color;
  final Color backgroundFocusColor;

  const TrailerButton(this.item,
      {this.padding = const EdgeInsets.all(10),
      this.size = 26,
      this.color = Colors.blue,
      this.backgroundFocusColor = Colors.black12});

  @override
  State<StatefulWidget> createState() {
    return _TrailerButtonState();
  }
}

class _TrailerButtonState extends State<TrailerButton> {
  var fToast;
  late FocusNode _node;
  late Color _focusColor;

  @override
  void initState() {
    _focusColor = Colors.transparent;
    _node = FocusNode(descendantsAreFocusable: false, skipTraversal: false);
    _node.addListener(_onFocusChange);
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  void _onFocusChange() {
    if (_node.hasFocus) {
      setState(() {
        _focusColor = widget.color;
      });
    } else {
      setState(() {
        _focusColor = Colors.transparent;
      });
    }
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          foregroundDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: _focusColor)),
          child: InkWell(
              focusNode: _node,
              focusColor: widget.backgroundFocusColor,
              hoverColor: widget.backgroundFocusColor,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              onTap: () => playTrailer(context),
              child: Padding(
                padding: widget.padding,
                child:
                    Icon(Icons.movie, color: widget.color, size: widget.size),
              ))),
    );
  }

  void playTrailer(BuildContext context) async {
    final youtubeUrl = widget.item.getTrailer();
    final itemURi = Uri.parse(youtubeUrl);
    final videoId = itemURi.queryParameters['v'];
    final url = await getYoutubeUrl(videoId!);

    var playerWidget;
    if (Platform.isLinux || Platform.isWindows) {
      playerWidget = await _initVlcComputerPlayer(url.toString());
    } else {
      playerWidget = await _initVlcPhonePlayer(url.toString());
    }

    await customRouter
        .push(StreamRoute(player: playerWidget, item: widget.item));
  }

  Future<Widget> _initVlcComputerPlayer(String url) async {
    final player = await CommonStreamVLCComputer.setupDataFromUrl(url: url);
    final streamModel = StreamingProvider();
    streamModel.setItem(widget.item);
    streamModel.setIsDirectPlay(true);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        vlc.Video(
          player: player,
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
          aspectRatio: widget.item.getAspectRatio(),
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
