import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/main.dart';

class DetailHeaderBar extends StatelessWidget {
  final double height;
  final Color color;

  DetailHeaderBar({Key key, @required this.height, @required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var statusBarHeight =
        MediaQuery.of(navigatorKey.currentContext).padding.top;
    return Container(
      height: statusBarHeight + height,
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black87,
            Colors.black45,
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.8, 1],
        ),
      ),
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
        ],
      ),
    );
  }
}
