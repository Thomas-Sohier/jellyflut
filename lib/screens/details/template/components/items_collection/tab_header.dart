import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:universal_io/io.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/palette_button.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';

class TabHeader extends SliverPersistentHeaderDelegate {
  final Future<Category> seasons;
  final TabController? tabController;
  final EdgeInsets padding;
  static const height = 80.0;

  TabHeader(
      {Key? key,
      required this.seasons,
      this.tabController,
      this.padding = const EdgeInsets.only(left: 12)});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    BlocProvider.of<DetailsBloc>(context).shrinkOffsetChanged(shrinkOffset);

    return FutureBuilder<Category>(
        future: seasons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ClipRRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: SizedBox(
                    height: height,
                    child: StreamBuilder<bool>(
                        initialData: false,
                        stream: BlocProvider.of<DetailsBloc>(context)
                            .pinnedHeaderStream,
                        builder: (_, headerSnapsot) => AnimatedPadding(
                            padding: headerSnapsot.data!
                                ? padding.copyWith(left: padding.left + 40)
                                : padding,
                            duration: Duration(milliseconds: 200),
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: getTabsHeader(
                                    snapshot.data?.items ?? <Item>[])))),
                  )),
            );
          }
          return const SizedBox(height: height);
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
    for (var item in items) {
      headers.add(tabHeader(item, items.indexOf(item)));
    }
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
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
