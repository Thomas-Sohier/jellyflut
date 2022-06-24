import 'package:flutter/material.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class ProgressBar extends StatelessWidget {
  final Item item;

  const ProgressBar({required this.item});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            child: Align(
                alignment: Alignment.bottomLeft, child: progressBarShadow())),
        Positioned(
            child: Align(
                alignment: Alignment.bottomLeft,
                child: progressBarBackground())),
        Positioned(
            child:
                Align(alignment: Alignment.bottomLeft, child: progressBar())),
      ],
    );
  }

  Widget progressBar() {
    return FractionallySizedBox(
        widthFactor: item.getPercentPlayed(),
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
      '${(item.getPercentPlayed() * 100).round()} %',
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
}
