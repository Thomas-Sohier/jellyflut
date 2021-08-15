import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:palette_generator/palette_generator.dart';

class PlayButton extends StatelessWidget {
  final Item item;
  final Future<PaletteGenerator> paletteColorFuture;

  const PlayButton(
      {Key? key, required this.item, required this.paletteColorFuture})
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
      futurePaletteColors: paletteColorFuture,
    );
  }
}
