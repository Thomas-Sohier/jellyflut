import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/detailedItemPoster.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/items/carrousselProvider.dart';
import 'package:jellyflut/providers/items/itemsProvider.dart';
import 'package:jellyflut/screens/collection/collectionBloc.dart';
import 'package:jellyflut/screens/collection/collectionEvent.dart';
import 'package:jellyflut/screens/collection/listItemsSkeleton.dart';
import 'package:jellyflut/services/item/itemService.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart';

class ListItems extends StatefulWidget {
  final double headerBarHeight;
  final Item parentItem;
  const ListItems(
      {Key? key, this.headerBarHeight = 64, required this.parentItem})
      : super(key: key);

  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  late final ScrollController _scrollController;
  late final CarrousselProvider carrousselProvider;
  late final bool canPop;
  late final CollectionBloc collectionBloc;

  @override
  void initState() {
    super.initState();
    collectionBloc = CollectionBloc()..initialize(widget.parentItem);
    canPop = customRouter.canPopSelfOrChildren;
    carrousselProvider = CarrousselProvider();
    _scrollController = ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 500) {
      collectionBloc
          .add(CollectionEvent(items: [], status: CollectionStatus.LOAD_MORE));
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildItemsGrid();
  }

  Widget buildItemsGrid() {
    // var spacing = numberOfItemRow
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final paddingTop = canPop ? 82.0 : (8.0 + statusBarHeight);
    return Padding(
        padding: EdgeInsets.fromLTRB(8, paddingTop, 8, 8), child: view());
  }

  Widget view() {
    return CustomScrollView(controller: _scrollController, slivers: <Widget>[
      // if (widget.parentItem.isPlayable())
      //   SliverToBoxAdapter(child: carouselSlider([])),
      SliverToBoxAdapter(
        child: Column(children: [
          sortItems(),
        ]),
      ),
      StreamBuilder<List<Item>>(
          stream: collectionBloc.stream,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return gridItems(snapshot.data!);
              }
              return emptyErrorStream();
            } else if (snapshot.hasError) {
              return SliverToBoxAdapter(child: Center(child: Text('Error')));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return SliverToBoxAdapter(child: ListItemsSkeleton());
            }
            return SizedBox();
          }),
    ]);
  }

  Widget gridItems(List<Item> items) {
    final size = MediaQuery.of(context).size;
    final numberOfItemRow = (size.width / itemHeight * (4 / 3)).round();
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: items.first.getPrimaryAspectRatio(),
            crossAxisCount: numberOfItemRow,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5),
        delegate: SliverChildBuilderDelegate((BuildContext c, int index) {
          return ItemPoster(
            items.elementAt(index),
          );
        }, childCount: items.length));
  }

  Widget emptyErrorStream() {
    return SliverFillRemaining(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          Text('Empty collection')
        ]));
  }

  Widget sortItems() {
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.date_range,
              color: Colors.white,
            ),
            onPressed: () => collectionBloc.add(CollectionEvent(
                items: collectionBloc.state.toList(),
                status: CollectionStatus.SORT_DATE)),
          ),
          IconButton(
            icon: Icon(
              Icons.sort_by_alpha,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () => collectionBloc.add(CollectionEvent(
                items: collectionBloc.state.toList(),
                status: CollectionStatus.SORT_NAME)),
          ),
        ],
      ),
    );
  }

  Widget carouselSlider(List<Item> items) {
    return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: (16 / 9),
            viewportFraction: (16 / 9) / 2,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, _) =>
                carrousselProvider.changeItem(items[index]),
            height: 300),
        items: items.map((item) {
          var heroTag = item.id + Uuid().v4();
          return DetailedItemPoster(
            item: item,
            textColor: Colors.white,
            heroTag: heroTag,
          );
        }).toList());
  }
}
