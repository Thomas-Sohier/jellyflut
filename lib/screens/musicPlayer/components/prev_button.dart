import 'package:flutter/material.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';

class PrevButton extends StatefulWidget {
  final Color color;
  final Color backgroundColor;
  PrevButton({super.key, required this.color, required this.backgroundColor});

  @override
  _PrevButtonState createState() => _PrevButtonState();
}

class _PrevButtonState extends State<PrevButton> {
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
        onPressed: () => musicProvider.previous(),
        shape: CircleBorder(),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: widget.backgroundColor,
              boxShadow: shadows,
              shape: BoxShape.circle),
          child: Icon(
            Icons.skip_previous,
            color: widget.color,
            size: 32,
          ),
        ));
  }
}
