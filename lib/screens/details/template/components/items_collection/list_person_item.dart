import 'package:flutter/material.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';

import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

// seriesFuture = context.read<ItemsRepository>().getCategory(
//         includeItemTypes: ItemType.Series.name,
//         sortBy: const [HttpRequestSortBy.ProductionYear, HttpRequestSortBy.SortName],
//         personIds: widget.item.id,
//         fields: FIELDS);
//     moviesFuture = context.read<ItemsRepository>().getCategory(
//         includeItemTypes: ItemType.Movie.name,
//         sortBy: const [HttpRequestSortBy.ProductionYear, HttpRequestSortBy.SortName],
//         personIds: widget.item.id,
//         fields: FIELDS);
//     audiosFuture = context.read<ItemsRepository>().getCategory(
//         includeItemTypes: ItemType.Audio.name,
//         sortBy: const [HttpRequestSortBy.ProductionYear, HttpRequestSortBy.SortName],
//         personIds: widget.item.id,
//         fields: FIELDS);

class ListPersonItem extends StatelessWidget {
  final Item item;

  const ListPersonItem({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      ListItems.fromItem(
          parentItem: item,
          listType: ListType.poster,
          horizontalListPosterHeight: 250,
          showTitle: true,
          showIfEmpty: false,
          showSorting: false),
      const SizedBox(height: 24),
      ListItems.fromItem(
          parentItem: item,
          listType: ListType.poster,
          horizontalListPosterHeight: 250,
          showTitle: true,
          showIfEmpty: false,
          showSorting: false),
      const SizedBox(height: 24),
      ListItems.fromItem(
          parentItem: item,
          listType: ListType.poster,
          horizontalListPosterHeight: 250,
          showTitle: true,
          showIfEmpty: false,
          showSorting: false)
    ]);
  }
}
