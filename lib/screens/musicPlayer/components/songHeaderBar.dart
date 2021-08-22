import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/BackButton.dart' as bb;
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/musicPlayer/components/songPlaylist.dart';
import 'package:jellyflut/shared/responsiveBuilder.dart';
import 'package:jellyflut/shared/theme.dart';

class SongHeaderBar extends StatelessWidget {
  final double height;
  final Color color;
  final ThemeData playlistThemeData = ThemeData(
      brightness: Brightness.dark,
      primaryColor: jellyPurple,
      backgroundColor: Colors.grey.shade900);

  SongHeaderBar({Key? key, required this.height, required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    return ResponsiveBuilder.builder(
        mobile: () => phoneTemplate(statusBarHeight, context),
        tablet: () => largeScreenTemplate(statusBarHeight, context),
        desktop: () => largeScreenTemplate(height, context));
  }

  Widget largeScreenTemplate(double statusBarHeight, BuildContext context) {
    return SizedBox(
      height: statusBarHeight + height,
      child: Row(
        children: [bb.BackButton()],
      ),
    );
  }

  Widget phoneTemplate(double statusBarHeight, BuildContext context) {
    return SizedBox(
      height: statusBarHeight + height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          bb.BackButton(),
          Spacer(),
          InkWell(
              onTap: () => customRouter.push(PlaylistRoute(
                  body: SongPlaylist(
                    backgroundColor: playlistThemeData.backgroundColor,
                    color: Colors.white,
                  ),
                  playlistTheme: playlistThemeData)),
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Icon(
                Icons.album,
                color: color,
                size: 30,
              )),
        ],
      ),
    );
  }
}
