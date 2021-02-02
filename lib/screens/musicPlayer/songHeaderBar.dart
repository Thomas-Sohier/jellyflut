import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/slideRightRoute.dart';
import 'package:jellyflut/screens/musicPlayer/songPlaylist.dart';

class SongHeaderBar extends StatelessWidget {
  final double height;
  final Color color;

  SongHeaderBar({Key key, @required this.height, @required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
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
                    page: SongPlaylist(
                      backgroundColor: Colors.grey[900],
                      color: color,
                    ),
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
