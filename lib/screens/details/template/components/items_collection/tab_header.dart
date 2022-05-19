import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class TabHeader extends SliverPersistentHeaderDelegate {
  final Future<Category> seasons;
  final TabController? tabController;

  TabHeader({Key? key, required this.seasons, this.tabController});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapContent) {
    return FutureBuilder<Category>(
        future: seasons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ClipRRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          getTabsHeader(snapshot.data?.items ?? <Item>[]))),
            );
          }
          return const SizedBox(height: 50.0);
        });
  }

  Widget safeAreaBuilder(Widget child) {
    if (Platform.isAndroid || Platform.isIOS) {
      return SafeArea(child: child);
    }
    return child;
  }

  List<Widget> getTabsHeader(List<Item> items) {
    final headers = <Widget>[];
    final length = items.length;
    items.sort((Item item1, Item item2) =>
        item1.indexNumber?.compareTo(item2.indexNumber ?? length + 1) ??
        length + 1);
    items.forEach(
        (Item item) => headers.add(tabHeader(item, items.indexOf(item))));
    return headers;
  }

  Widget tabHeader(Item item, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: PaletteButton(
        item.name,
        onPressed: () => tabController?.animateTo(index),
        borderRadius: 4,
        maxHeight: 50,
        minWidth: 40,
        maxWidth: 150,
      ),
    );
  }

  @override
  double get maxExtent => 80.0;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
