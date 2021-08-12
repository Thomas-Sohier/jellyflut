import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/item.dart';

class LikeButton extends StatelessWidget {
  final Item item;

  const LikeButton({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaletteButton(
      'Like',
      () => favItem(item.id),
      minWidth: 40,
      maxWidth: 150,
      borderRadius: 4,
      icon: item.isFavorite()
          ? Icon(Icons.favorite, color: Colors.red.shade900)
          : Icon(
              Icons.favorite_outline,
              color: Colors.black87,
            ),
    );
  }
}
