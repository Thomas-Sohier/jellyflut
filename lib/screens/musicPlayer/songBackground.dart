import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SongBackground extends StatefulWidget {
  final Color color;
  SongBackground({Key key, @required this.color}) : super(key: key);

  @override
  _SongBackgroundState createState() => _SongBackgroundState();
}

class _SongBackgroundState extends State<SongBackground> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        decoration: BoxDecoration(color: widget.color),
      ),
    );
  }
}
