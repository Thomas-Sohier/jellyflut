import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/components/list_items.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/shared.dart';

class ListPersonItem extends StatefulWidget {
  final Item item;

  const ListPersonItem({Key? key, required this.item}) : super(key: key);

  @override
  _ListPersonItemState createState() => _ListPersonItemState();
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
        includeItemTypes: getEnumValue(ItemType.SERIES.toString()),
        sortBy: 'ProductionYear,Sortname',
        personIds: widget.item.id,
        fields: FIELDS);
    moviesFuture = ItemService.getItems(
        includeItemTypes: getEnumValue(ItemType.MOVIE.toString()),
        sortBy: 'ProductionYear,Sortname',
        personIds: widget.item.id,
        fields: FIELDS);
    audiosFuture = ItemService.getItems(
        includeItemTypes: getEnumValue(ItemType.AUDIO.toString()),
        sortBy: 'ProductionYear,Sortname',
        personIds: widget.item.id,
        fields: FIELDS);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 24,
      ),
      ListItems.fromFuture(itemsFuture: moviesFuture, lisType: ListType.POSTER),
      SizedBox(
        height: 24,
      ),
      ListItems.fromFuture(itemsFuture: seriesFuture, lisType: ListType.POSTER),
      SizedBox(
        height: 24,
      ),
      ListItems.fromFuture(itemsFuture: audiosFuture, lisType: ListType.POSTER)
    ]);
  }
}
