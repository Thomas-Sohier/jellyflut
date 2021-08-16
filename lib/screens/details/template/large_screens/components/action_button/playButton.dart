import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/item.dart';

class PlayButton extends StatelessWidget {
  final Item item;
  final Future<Color> dominantColorFuture;

  const PlayButton(
      {Key? key, required this.item, required this.dominantColorFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton(
      'Play',
      onPressed: () => item.playItem(),
      borderRadius: 4,
      minWidth: 40,
      maxWidth: 150,
      icon: Icon(Icons.play_arrow, color: Colors.black87),
      dominantColorFuture: dominantColorFuture,
    );
  }
}
