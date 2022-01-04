import 'dart:ui';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart' as l;
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/items/carroussel_provider.dart';
import 'package:jellyflut/screens/collection/bloc/collection_bloc.dart';
import 'package:jellyflut/screens/collection/carousel_slider_builder.dart';
import 'package:jellyflut/screens/collection/list_items_skeleton.dart';

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
    carrousselProvider = CarrousselProvider();
    collectionBloc = CollectionBloc()..initialize(widget.parentItem);
    canPop = customRouter.canPopSelfOrChildren;
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
    return BlocProvider.value(
      value: collectionBloc,
      child: LayoutBuilder(builder: (context, constraints) {
        return ClipRect(
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor.withAlpha(170)),
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                    child: Container(
                        decoration:
                            BoxDecoration(color: Colors.white.withOpacity(0.0)),
                        child: buildList()))));
      }),
    );
  }

  Widget buildList() {
    return BlocBuilder<CollectionBloc, CollectionState>(
        bloc: collectionBloc,
        builder: (context, collectionState) {
          if (collectionState is CollectionLoadedState) {
            if (collectionBloc.items.isNotEmpty) {
              final c = Category(
                  items: collectionBloc.items,
                  startIndex: 0,
                  totalRecordCount: collectionBloc.items.length);
              return l.ListItems.fromList(
                category: c,
                lisType: ListType.GRID,
              );
            }
            return Center(child: emptyErrorStream());
          } else if (collectionState is CollectionErrorState) {
            return Center(child: Text('error'.tr()));
          } else if (collectionState is CollectionLoadingState) {
            return ListItemsSkeleton();
          }
          return const SizedBox();
        });
  }

  Widget buildItemsGrid(BoxConstraints constraints) {
    // var spacing = numberOfItemRow
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final paddingTop = canPop ? 82.0 : (8.0 + statusBarHeight);
    return CustomScrollView(controller: _scrollController, slivers: <Widget>[
      SliverToBoxAdapter(child: SizedBox(height: paddingTop)),
      if (widget.parentItem.isCollectionPlayable())
        SliverToBoxAdapter(child: CarouselSliderBuilder()),
      SliverToBoxAdapter(
        child: Column(children: [
          sortItems(),
        ]),
      ),
      BlocBuilder<CollectionBloc, CollectionState>(
          bloc: collectionBloc,
          builder: (context, collectionState) {
            if (collectionState is CollectionLoadedState) {
              if (collectionBloc.items.isNotEmpty) {
                return gridItems(collectionBloc.items, constraints);
              }
              return emptyErrorStream();
            } else if (collectionState is CollectionErrorState) {
              return SliverToBoxAdapter(
                  child: Center(child: Text('error'.tr())));
            } else if (collectionState is CollectionLoadingState) {
              return SliverToBoxAdapter(child: ListItemsSkeleton());
            }
            return SliverToBoxAdapter(child: const SizedBox());
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          Text('empty_collection'.tr())
        ]);
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
                items: collectionBloc.items,
                status: CollectionStatus.SORT_DATE)),
          ),
          IconButton(
            icon: Icon(
              Icons.sort_by_alpha,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () => collectionBloc.add(CollectionEvent(
                items: collectionBloc.items,
                status: CollectionStatus.SORT_NAME)),
          ),
        ],
      ),
    );
  }
}
