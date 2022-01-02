import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class ProgressBar extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const ProgressBar({required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    final duration = startDate.difference(endDate);
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
    final duration = startDate.difference(endDate);
    final currentDuration = DateTime.now().difference(endDate);
    final percentPlayed =
        duration.inMilliseconds / currentDuration.inMilliseconds;
    return FractionallySizedBox(
        widthFactor: percentPlayed,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(80.0)),
              color: Colors.white),
          width: double.maxFinite,
          height: 3,
        ));
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
