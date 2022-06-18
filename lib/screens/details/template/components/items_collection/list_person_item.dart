import 'package:flutter/material.dart';

import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_service.dart';

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
    seriesFuture = ItemService.getItems(
        includeItemTypes: ItemType.SERIES.value,
        sortBy: 'ProductionYear,Sortname',
        personIds: widget.item.id,
        fields: FIELDS);
    moviesFuture = ItemService.getItems(
        includeItemTypes: ItemType.MOVIE.value,
        sortBy: 'ProductionYear,Sortname',
        personIds: widget.item.id,
        fields: FIELDS);
    audiosFuture = ItemService.getItems(
        includeItemTypes: ItemType.AUDIO.value,
        sortBy: 'ProductionYear,Sortname',
        personIds: widget.item.id,
        fields: FIELDS);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
