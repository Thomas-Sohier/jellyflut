import 'package:flutter/material.dart';
import 'package:jellyflut/models/enum/itemType.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/listCollectionItem.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/listMusicItem.dart';
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/listVideoItem.dart';
import 'package:jellyflut/services/item/itemService.dart';
import 'package:jellyflut/shared/shared.dart';

class Collection extends StatefulWidget {
  final Item item;

  const Collection(this.item);

  @override
  State<StatefulWidget> createState() {
    return _CollectionState();
  }
}

const double gapSize = 20;

class _CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Align(
        alignment: Alignment.topCenter, //or choose another Alignment
        child: showCollection(),
      ),
    );
  }

  Widget showCollection() {
    switch (widget.item.type) {
      case ItemType.MUSICALBUM:
        return ListMusicItem(item: widget.item);
      case ItemType.SEASON:
        return ListVideoItem(item: widget.item);
      case ItemType.SERIES:
        return ListCollectionItem(item: widget.item);
      case ItemType.MUSICARTIST:
        return musicArtistItem(item: widget.item);
      case ItemType.PERSON:
        return personItem(item: widget.item);
      default:
        return Container();
    }
  }

  Widget musicArtistItem({required Item item}) {
    return Column(children: [
      ListCollectionItem(
        item: item,
        future: ItemService.getItems(
            includeItemTypes: getEnumValue(ItemType.MUSICALBUM.toString()),
            sortBy: 'ProductionYear,Sortname',
            albumArtistIds: item.id,
            fields:
                'AudioInfo,SeriesInfo,ParentId,PrimaryImageAspectRatio,BasicSyncInfo,AudioInfo,SeriesInfo,ParentId,PrimaryImageAspectRatio,BasicSyncInfo'),
      )
    ]);
  }

  Widget personItem({required Item item}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 24,
      ),
      ListCollectionItem(
        item: item,
        title: 'Movies',
        future: ItemService.getItems(
            includeItemTypes: getEnumValue(ItemType.MOVIE.toString()),
            sortBy: 'ProductionYear,Sortname',
            personIds: item.id,
            fields:
                'AudioInfo,SeriesInfo,ParentId,PrimaryImageAspectRatio,BasicSyncInfo,AudioInfo,SeriesInfo,ParentId,PrimaryImageAspectRatio,BasicSyncInfo'),
      ),
      SizedBox(
        height: 24,
      ),
      ListCollectionItem(
        item: item,
        title: 'Series',
        future: ItemService.getItems(
            includeItemTypes: getEnumValue(ItemType.SERIES.toString()),
            sortBy: 'ProductionYear,Sortname',
            personIds: item.id,
            fields:
                'AudioInfo,SeriesInfo,ParentId,PrimaryImageAspectRatio,BasicSyncInfo,AudioInfo,SeriesInfo,ParentId,PrimaryImageAspectRatio,BasicSyncInfo'),
      ),
    ]);
  }
}

Future collectionItems(Item item) {
  // If it's a series or a music album we get every item
  if (item.type == ItemType.MUSICALBUM || item.type == ItemType.SERIES) {
    return ItemService.getItems(
        parentId: item.id, limit: 100, fields: 'ImageTags', filter: 'IsFolder');
  } else {
    return ItemService.getEpsiode(item.seriesId!, item.id);
  }
}
