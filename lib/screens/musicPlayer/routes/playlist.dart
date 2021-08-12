import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class PlaylistRoute extends StatelessWidget {
  const PlaylistRoute(
      {Key? key, required this.body, required this.playlistTheme})
      : super(key: key);

  final ThemeData playlistTheme;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: playlistTheme,
        child: Scaffold(
            backgroundColor: playlistTheme.backgroundColor,
            appBar: AppBar(
              title: Text('Playlist'),
              systemOverlayStyle:
                  SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
              backgroundColor: playlistTheme.backgroundColor,
            ),
            body: body));
  }
}
