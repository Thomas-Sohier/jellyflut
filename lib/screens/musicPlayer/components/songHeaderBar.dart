import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/slideRightRoute.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/screens/musicPlayer/components/songPlaylist.dart';
import 'package:jellyflut/screens/musicPlayer/routes/playlist.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
    var statusBarHeight =
        MediaQuery.of(navigatorKey.currentContext!).padding.top;
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) =>
            phoneTemplate(statusBarHeight, context),
        tablet: (BuildContext context) =>
            largeScreenTemplate(statusBarHeight, context),
        desktop: (BuildContext context) =>
            largeScreenTemplate(height, context));
  }

  Widget largeScreenTemplate(double statusBarHeight, BuildContext context) {
    return SizedBox(
      height: statusBarHeight + height,
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Icon(
              Icons.arrow_back,
              color: color,
              size: 30,
            ),
          ),
        ],
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
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: Icon(
              Icons.arrow_back,
              color: color,
              size: 30,
            ),
          ),
          Spacer(),
          InkWell(
              onTap: () => Navigator.push(
                  context,
                  SlideRightRoute(
                    page: PlaylistRoute(
                        playlistTheme: playlistThemeData,
                        body: SongPlaylist(
                          backgroundColor: playlistThemeData.backgroundColor,
                          color: Colors.white,
                        )),
                  )),
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
