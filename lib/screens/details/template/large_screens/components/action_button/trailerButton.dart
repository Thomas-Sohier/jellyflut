import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/item.dart';

class TrailerButton extends StatelessWidget {
  final Item item;

  const TrailerButton({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton('Trailer', () => favItem(item.id),
        minWidth: 40,
        maxWidth: 150,
        borderRadius: 4,
        icon: Icon(Icons.movie, color: Colors.black87));
  }
}
