import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';

import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class ListPersonItem extends StatefulWidget {
  final Item item;

  const ListPersonItem({super.key, required this.item});

  @override
  State<ListPersonItem> createState() => _ListPersonItemState();
}

class _ListPersonItemState extends State<ListPersonItem> {
  final FIELDS =
      'AudioInfo,SeriesInfo,ParentId,RecursiveItemCount,PrimaryImageAspectRatio,BasicSyncInfo,AudioInfo,SeriesInfo,ParentId,PrimaryImageAspectRatio,BasicSyncInfo';
  late final seriesFuture;
  late final moviesFuture;
  late final audiosFuture;

  @override
  void initState() {
    super.initState();
    seriesFuture = context.read<ItemsRepository>().getCategory(
        includeItemTypes: ItemType.Series.name,
        sortBy: const [HttpRequestSortBy.ProductionYear, HttpRequestSortBy.SortName],
        personIds: widget.item.id,
        fields: FIELDS);
    moviesFuture = context.read<ItemsRepository>().getCategory(
        includeItemTypes: ItemType.Movie.name,
        sortBy: const [HttpRequestSortBy.ProductionYear, HttpRequestSortBy.SortName],
        personIds: widget.item.id,
        fields: FIELDS);
    audiosFuture = context.read<ItemsRepository>().getCategory(
        includeItemTypes: ItemType.Audio.name,
        sortBy: const [HttpRequestSortBy.ProductionYear, HttpRequestSortBy.SortName],
        personIds: widget.item.id,
        fields: FIELDS);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      ListItems.fromFuture(
          itemsFuture: moviesFuture,
          listType: ListType.POSTER,
          horizontalListPosterHeight: 250,
          showTitle: true,
          showIfEmpty: false,
          showSorting: false),
      const SizedBox(height: 24),
      ListItems.fromFuture(
          itemsFuture: seriesFuture,
          listType: ListType.POSTER,
          horizontalListPosterHeight: 250,
          showTitle: true,
          showIfEmpty: false,
          showSorting: false),
      const SizedBox(height: 24),
      ListItems.fromFuture(
          itemsFuture: audiosFuture,
          listType: ListType.POSTER,
          horizontalListPosterHeight: 250,
          showTitle: true,
          showIfEmpty: false,
          showSorting: false)
    ]);
  }
}
