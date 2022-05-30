import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:jellyflut/screens/details/template/components/details/poster.dart';

class Header extends StatelessWidget {
  final Item item;
  final BoxConstraints constraints;

  const Header({super.key, required this.item, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return OverflowBar(
        alignment: MainAxisAlignment.spaceEvenly,
        overflowAlignment: OverflowBarAlignment.center,
        overflowDirection: VerticalDirection.down,
        overflowSpacing: 10,
        spacing: 20,
        children: [
          if (constraints.maxWidth < 960)
            ConstrainedBox(
                constraints: BoxConstraints(maxHeight: itemPosterHeight),
                child: Poster(item: item)),
          if (item.hasLogo()) Logo(item: item),
        ]);
  }
}
