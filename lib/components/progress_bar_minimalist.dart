import 'package:flutter/material.dart';

class ProgressBarMinimalist extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const ProgressBarMinimalist({required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            child: Align(
                alignment: Alignment.center, child: progressBarBackground())),
        Positioned(
            child:
                Align(alignment: Alignment.centerLeft, child: progressBar())),
      ],
    );
  }

  Widget progressBar() {
    final duration = endDate.difference(startDate);
    final currentDuration = endDate.difference(DateTime.now());
    final percentPlayed =
        currentDuration.inMilliseconds / duration.inMilliseconds;
    return FractionallySizedBox(
        widthFactor: percentPlayed < 0 ? 0 : percentPlayed,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(80.0)),
              color: Colors.white),
          width: double.maxFinite,
          height: 2,
        ));
  }

  Widget progressBarBackground() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
        color: Colors.black87,
      ),
      width: double.maxFinite,
      height: 1,
    );
  }
}
