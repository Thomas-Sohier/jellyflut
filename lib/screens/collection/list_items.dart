import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/detailed_item_poster.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/items/carroussel_provider.dart';
import 'package:jellyflut/screens/collection/collection_bloc.dart';
import 'package:jellyflut/screens/collection/collection_event.dart';
import 'package:jellyflut/screens/collection/list_items_skeleton.dart';
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
    collectionBloc.close();
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
    return LayoutBuilder(builder: (context, constraints) {
      return buildItemsGrid(constraints);
    });
  }

  Widget buildItemsGrid(BoxConstraints constraints) {
    // var spacing = numberOfItemRow
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final paddingTop = canPop ? 82.0 : (8.0 + statusBarHeight);
    return CustomScrollView(controller: _scrollController, slivers: <Widget>[
      SliverToBoxAdapter(child: SizedBox(height: paddingTop)),
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
                return gridItems(snapshot.data!, constraints);
              }
              return emptyErrorStream();
            } else if (snapshot.hasError) {
              return SliverToBoxAdapter(
                  child: Center(child: Text('error'.tr())));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return SliverToBoxAdapter(child: ListItemsSkeleton());
            }
            return SizedBox();
          }),
    ]);
  }

  Widget gridItems(List<Item> items, BoxConstraints constraints) {
    final itemAspectRatio = items.first.getPrimaryAspectRatio(showParent: true);
    final numberOfItemRow =
        (constraints.maxWidth / (itemPosterHeight * itemAspectRatio)).round();
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: items.first.getPrimaryAspectRatio(),
            crossAxisCount: numberOfItemRow,
            mainAxisExtent: itemPosterHeight + itemPosterLabelHeight,
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
          Text('empty_collection'.tr())
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
