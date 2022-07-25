import 'package:flutter/material.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class ProgressBar extends StatelessWidget {
  final Item item;

  const ProgressBar({required this.item});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(child: Align(alignment: Alignment.bottomLeft, child: _ProgressBarShadow())),
        const Positioned(child: Align(alignment: Alignment.bottomLeft, child: _ProgressBarBackground())),
        Positioned(child: Align(alignment: Alignment.bottomLeft, child: _ProgressBarForeground(item: item))),
      ],
    );
  }
}

class _ProgressBarForeground extends StatelessWidget {
  final Item item;
  const _ProgressBarForeground({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: item.getPercentPlayed(),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(80.0)), color: Colors.white),
          width: double.maxFinite,
          height: 3,
        ));
  }
}

class _ProgressBarDurationPercent extends StatelessWidget {
  final Item item;
  const _ProgressBarDurationPercent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
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
}

class _ProgressBarBackground extends StatelessWidget {
  const _ProgressBarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
        color: Colors.black87,
      ),
      width: double.maxFinite,
      height: 3,
    );
  }
}

class _ProgressBarShadow extends StatelessWidget {
  const _ProgressBarShadow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
          boxShadow: [BoxShadow(blurRadius: 0, color: Colors.black87, spreadRadius: 1.5)]),
      width: double.maxFinite,
      height: 3,
    );
  }
}
