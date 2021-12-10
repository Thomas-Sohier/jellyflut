import 'package:flutter/material.dart';

import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';

class PrevButton extends StatefulWidget {
  final Color color;
  final Color backgroundColor;
  PrevButton({Key? key, required this.color, required this.backgroundColor})
      : super(key: key);

  @override
  _PrevButtonState createState() => _PrevButtonState();
}

class _PrevButtonState extends State<PrevButton> {
  late final MusicProvider musicProvider;
  late final FocusNode _node;
  final List<BoxShadow> shadows = [
    BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: 2)
  ];

  @override
  void initState() {
    _node = FocusNode();
    musicProvider = MusicProvider();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => musicProvider.previous(),
        node: _node,
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
