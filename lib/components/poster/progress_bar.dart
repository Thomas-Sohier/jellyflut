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
  const _ProgressBarForeground({required this.item});

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

class _ProgressBarBackground extends StatelessWidget {
  const _ProgressBarBackground();

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
  const _ProgressBarShadow();

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
