import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

import 'itemPoster.dart';

class ProgressBar extends StatelessWidget {
  final Item item;

  const ProgressBar({Key key, @required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: progressBarDurationPercent())),
          ],
        ),
        Stack(
          children: [
            Positioned(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: progressBarShadow())),
            Positioned(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: progressBarBackground())),
            Positioned(
                child: Align(
                    alignment: Alignment.centerLeft, child: progressBar())),
          ],
        )
      ],
    );
  }

  Widget progressBar() {
    return FractionallySizedBox(
        widthFactor: percentDuration(item),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(80.0)),
              color: Colors.white),
          width: double.maxFinite,
          height: 3,
        ));
  }

  Widget progressBarDurationPercent() {
    return Text(
      (percentDuration(item) * 100).round().toString() + ' %',
      textAlign: TextAlign.left,
      style: TextStyle(color: Colors.white, shadows: [
        Shadow(offset: Offset(0, -2), blurRadius: 4, color: Colors.black),
        Shadow(offset: Offset(-2, 0), blurRadius: 6, color: Colors.black),
        Shadow(offset: Offset(2, 0), blurRadius: 8, color: Colors.black)
      ]),
    );
  }

  Widget progressBarBackground() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
        color: Colors.black87,
      ),
      width: double.maxFinite,
      height: 3,
    );
  }

  Widget progressBarShadow() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
          boxShadow: [
            BoxShadow(blurRadius: 0, color: Colors.black87, spreadRadius: 1.5)
          ]),
      width: double.maxFinite,
      height: 3,
    );
  }

  double percentDuration(Item item) {
    return item.userData.playbackPositionTicks / item.runTimeTicks;
  }
}
