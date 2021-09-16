import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class SlidingText extends StatelessWidget {
  const SlidingText({
    Key? key,
    required this.text,
    required this.fontSize,
    this.fontWeight = FontWeight.w600,
    this.velocity = 30.0,
    this.blankSpace = 65.0,
    this.startAfter = const Duration(milliseconds: 2000),
    this.pauseAfterRound = const Duration(milliseconds: 2000),
  }) : super(key: key);

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final double velocity;
  final double blankSpace;
  final Duration startAfter;
  final Duration pauseAfterRound;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: (fontSize + 13.0) * MediaQuery.of(context).textScaleFactor,
        child: AutoSizeText(text.trim(),
            minFontSize: fontSize,
            maxFontSize: fontSize,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontFamily: 'Quicksand'),
            overflowReplacement: Marquee(
              text: text,
              blankSpace: blankSpace,
              accelerationCurve: Curves.easeOutCubic,
              decelerationCurve: Curves.ease,
              velocity: velocity,
              startPadding: 6,
              startAfter: startAfter,
              pauseAfterRound: pauseAfterRound,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  fontFamily: 'Quicksand'),
            )));
  }
}
