import 'dart:math';
import 'dart:ui';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/list_items/components/list_items_sort_field_button.dart';
import 'package:jellyflut/components/outlined_button_selector.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/screens/form/fields/fields_enum.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'bloc/collection_bloc.dart';
import 'components/episode_item.dart';
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
  final double gridPosterHeight;
  final ScrollPhysics physics;

  const ListItems({
    super.key,
    this.parentItem,
    this.items,
    this.fetchMethod,
    this.collectionBloc,
    this.showTitle = true,
    this.boxFit = BoxFit.cover,
    this.showIfEmpty = true,
    this.showSorting = true,
    this.horizontalListPosterHeight = 220,
    this.gridPosterHeight = 220,
    this.physics = const ClampingScrollPhysics(),
    this.listType = ListType.grid,
  }) : assert(
         (parentItem != null && items == null && fetchMethod == null) ||
             (parentItem == null && items != null && fetchMethod == null) ||
             (parentItem == null && items == null && fetchMethod != null),
         'Only one of parentItem, items or fetchMethod can be provided',
       );

  @override
  Widget build(BuildContext context) {
    Future<List<Item>> Function(int, int) buildFetcher() {
      if (parentItem != null) {
        final itemsRepo = context.read<ItemsRepository>();
        return (startIndex, limit) async {
          final category = await itemsRepo.getCategory(parentId: parentItem!.id, startIndex: startIndex, limit: limit);
          return category.items;
        };
      }
      if (items != null) {
        final localItems = items!;
        return (startIndex, limit) async {
          if (startIndex >= localItems.length) return [];
          return localItems.sublist(startIndex, min(startIndex + limit, localItems.length));
        };
      }
      return fetchMethod!;
    }

    final bloc =
        collectionBloc ??
              CollectionBloc(
                fetchMethod: buildFetcher(),
                listType: listType,
                physics: physics,
                horizontalListPosterHeight: horizontalListPosterHeight,
                gridPosterHeight: gridPosterHeight,
                showTitle: showTitle,
                showSorting: showSorting,
              )
          ..add(CollectionFetchStarted());

    return BlocProvider<CollectionBloc>.value(value: bloc, child: const ListItemsView());
  }
}

class ListItemsView extends StatefulWidget {
  const ListItemsView({super.key});

  @override
  State<ListItemsView> createState() => _ListItemsViewState();
}

class _ListItemsViewState extends State<ListItemsView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 500) {
      context.read<CollectionBloc>().add(CollectionFetchMore());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CollectionBloc>();
    final list = BlocBuilder<CollectionBloc, CollectionState>(
      buildWhen: (p, c) => p.status != c.status || p.items.length != c.items.length,
      builder: (context, state) {
        switch (state.status) {
          case CollectionStatus.initial:
          case CollectionStatus.loading:
            return const ListItemsSkeleton();
          case CollectionStatus.failure:
            return Center(child: Text('error'.tr()));
          case CollectionStatus.success:
          case CollectionStatus.loadingMore:
            if (state.items.isEmpty) {
              return Center(child: Text('empty_collection'.tr()));
            }
            return ListTitle(
              item: state.items.first,
              showTitle: bloc.showTitle, // Lit la propriété depuis le BLoC
              child: CollectionListView(controller: _scrollController),
            );
        }
      },
    );

    if (bloc.showSorting) {
      // Lit la propriété depuis le BLoC
      return ListItemsSort(child: Expanded(child: list));
    }
    return list;
  }
}

class CollectionListView extends StatelessWidget {
  final ScrollController controller;
  const CollectionListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final listType = context.select((CollectionBloc bloc) => bloc.state.listType);
    final items = context.select((CollectionBloc bloc) => bloc.state.items);

    switch (listType) {
      case ListType.list:
        return _ListItemsVerticalList(items: items, controller: controller);
      case ListType.poster:
        return _ListItemsHorizontalList(items: items, controller: controller);
      case ListType.grid:
        return _ListItemsGrid(items: items, controller: controller);
    }
  }
}
