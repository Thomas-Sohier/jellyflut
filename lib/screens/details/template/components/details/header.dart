import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/details/poster.dart';
import 'package:jellyflut/components/logo.dart';

class Header extends StatelessWidget {
  final Item item;
  final BoxConstraints constraints;

  const Header({super.key, required this.item, required this.constraints});

  @override
  Widget build(BuildContext context) {
    if (constraints.maxWidth < 960) {
      return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: itemPosterHeight),
            child: Poster(item: item)),
      );
    } else {
      if (item.hasLogo()) return Logo(item: item);
    }
    return const SizedBox();
  }
}
