import 'package:flutter/material.dart';

import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

class NextButton extends StatefulWidget {
  final Color color;
  final Color backgroundColor;
  NextButton({super.key, required this.color, required this.backgroundColor});

  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  late final MusicProvider musicProvider;
  final List<BoxShadow> shadows = [
    BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: 2)
  ];

  @override
  void initState() {
    musicProvider = MusicProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => musicProvider.next(),
        shape: CircleBorder(),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: widget.backgroundColor,
              boxShadow: shadows,
              shape: BoxShape.circle),
          child: Icon(
            Icons.skip_next,
            color: widget.color,
            size: 32,
          ),
        ));
  }
}
