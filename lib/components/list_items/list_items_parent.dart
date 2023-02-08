import 'dart:ui';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/list_items/components/episode_item.dart';
import 'package:jellyflut/components/list_items/components/list_items_sort_field_button.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../screens/form/fields/fields_enum.dart';
import 'bloc/collection_bloc.dart';
import 'components/music_item.dart';
import 'skeleton/list_items_skeleton.dart';

part 'components/carousel_background.dart';
part 'components/list_items_sort.dart';
part 'components/list_title.dart';
part 'list_types/list_items_grid.dart';
part 'list_types/list_items_horizontal_list.dart';
part 'list_types/list_items_vertical_list.dart';

class ListItems extends StatelessWidget {
  final Item? parentItem;
  final List<Item>? items;
  final Future<List<Item>> Function(int startIndex, int limit)? fetchMethod;
  final CollectionBloc? collectionBloc;
  final ListType listType;
  final BoxFit boxFit;
  final bool showTitle;
  final bool showIfEmpty;
  final bool showSorting;
  final double horizontalListPosterHeight;
  final double verticalListPosterHeight;
  final double gridPosterHeight;
  final ScrollPhysics physics;
  final Widget? notFoundPlaceholder;

  const ListItems.fromItem(
      {super.key,
      required this.parentItem,
      this.collectionBloc,
      this.notFoundPlaceholder,
      this.showTitle = false,
      this.boxFit = BoxFit.cover,
      this.showIfEmpty = true,
      this.showSorting = true,
      this.horizontalListPosterHeight = double.infinity,
      this.verticalListPosterHeight = double.infinity,
      this.gridPosterHeight = double.infinity,
      this.physics = const ClampingScrollPhysics(),
      this.listType = ListType.grid})
      : items = null,
        fetchMethod = null;

  const ListItems.fromList(
      {super.key,
      this.items = const <Item>[],
      this.collectionBloc,
      this.notFoundPlaceholder,
      this.showTitle = false,
      this.boxFit = BoxFit.cover,
      this.showIfEmpty = true,
      this.showSorting = true,
      this.horizontalListPosterHeight = double.infinity,
      this.verticalListPosterHeight = double.infinity,
      this.gridPosterHeight = double.infinity,
      this.physics = const ClampingScrollPhysics(),
      this.listType = ListType.grid})
      : parentItem = null,
        fetchMethod = null;

  const ListItems.fromCustomRequest(
      {super.key,
      required this.fetchMethod,
      this.collectionBloc,
      this.notFoundPlaceholder,
      this.showTitle = false,
      this.boxFit = BoxFit.cover,
      this.showIfEmpty = true,
      this.showSorting = true,
      this.horizontalListPosterHeight = double.infinity,
      this.verticalListPosterHeight = double.infinity,
      this.gridPosterHeight = double.infinity,
      this.physics = const ClampingScrollPhysics(),
      this.listType = ListType.grid})
      : parentItem = null,
        items = null;

  @override
  Widget build(BuildContext context) {
    if (collectionBloc != null) {
      return BlocProvider<CollectionBloc>.value(value: collectionBloc!, child: ListItemsView());
    }
    return BlocProvider<CollectionBloc>(
        create: (_) => CollectionBloc(
            itemsRepository: context.read<ItemsRepository>(),
            parentItem: parentItem,
            items: items,
            showIfEmpty: showIfEmpty,
            showSorting: showSorting,
            showTitle: showTitle,
            listType: listType,
            horizontalListPosterHeight: horizontalListPosterHeight,
            verticalListPosterHeight: verticalListPosterHeight,
            gridPosterHeight: gridPosterHeight,
            fetchMethod: fetchMethod)
          ..add(InitCollectionRequested()),
        child: ListItemsView());
  }
}

class ListItemsView extends StatefulWidget {
  ListItemsView({super.key});

  @override
  State<ListItemsView> createState() => _ListItemsViewState();
}

class _ListItemsViewState extends State<ListItemsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // scroll listener to add items on scroll only if loadmore function as been defined
    _scrollController.addListener(_scrollListener);
    context.read<CollectionBloc>().add(SetScrollController(scrollController: _scrollController));
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 500) {
      context.read<CollectionBloc>().add(LoadMoreItemsRequested());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<CollectionBloc>().state.showSorting) {
      return ListItemsSort(child: Expanded(child: buildList()));
    }
    return buildList();
  }

  Widget buildList() {
    return BlocBuilder<CollectionBloc, SeasonState>(
        buildWhen: (previous, current) =>
            previous.collectionStatus != current.collectionStatus || previous.items != current.items,
        builder: (_, state) {
          switch (state.collectionStatus) {
            case SeasonStatus.initial:
            case SeasonStatus.loading:
              return const ListItemsSkeleton();
            case SeasonStatus.loadingMore:
            case SeasonStatus.success:
              if (state.items.isNotEmpty) {
                return const CollectionListView();
              }
              return const EmptyCollectionView();
            case SeasonStatus.failure:
              return Center(child: Text('error'.tr()));
            default:
              return const SizedBox();
          }
        });
  }
}

class CollectionListView extends StatelessWidget {
  const CollectionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionBloc, SeasonState>(
        buildWhen: (previous, current) => previous.listType != current.listType,
        builder: (_, state) {
          switch (state.listType) {
            case ListType.list:
              return const VerticalListView();
            case ListType.poster:
              return const HorizontalListView();
            case ListType.grid:
              return const GridListView();
            default:
              return const GridListView();
          }
        });
  }
}

class VerticalListView extends StatelessWidget {
  const VerticalListView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select<CollectionBloc, List<Item>>((bloc) => bloc.state.items);
    return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: ListTitle(
          item: items.first,
          showTitle: context.read<CollectionBloc>().state.showTitle,
          child: ListItemsVerticalList(
            items: items,
            boxFit: BoxFit.cover,
            notFoundPlaceholder: null,
            scrollPhysics: AlwaysScrollableScrollPhysics(),
          ),
        ));
  }
}

class HorizontalListView extends StatelessWidget {
  const HorizontalListView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select<CollectionBloc, List<Item>>((bloc) => bloc.state.items);
    return ListTitle(
        item: items.first,
        showTitle: context.read<CollectionBloc>().state.showTitle,
        child: ListItemsHorizontalList(
            items: items,
            boxFit: BoxFit.cover,
            notFoundPlaceholder: null,
            scrollPhysics: AlwaysScrollableScrollPhysics()));
  }
}

class GridListView extends StatelessWidget {
  const GridListView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.select<CollectionBloc, List<Item>>((bloc) => bloc.state.items);
    return ListTitle(
        item: items.first,
        showTitle: context.read<CollectionBloc>().state.showTitle,
        child: ListItemsGrid(
          items: items,
          boxFit: BoxFit.cover,
          notFoundPlaceholder: null,
          scrollPhysics: AlwaysScrollableScrollPhysics(),
        ));
  }
}

class EmptyCollectionView extends StatelessWidget {
  const EmptyCollectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Center(child: Text('empty_collection'.tr())));
  }
}
