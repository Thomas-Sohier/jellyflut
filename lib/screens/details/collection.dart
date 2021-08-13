import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/show.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/itemType.dart';
import 'package:jellyflut/screens/details/listCollectionItem.dart';
import 'package:jellyflut/screens/details/listMusicItem.dart';
import 'package:jellyflut/screens/details/listVideoItem.dart';
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
    return Align(
      alignment: Alignment.topCenter, //or choose another Alignment
      child: showCollection(widget.item),
    );
  }

  Widget showCollection(Item item) {
    switch (item.type) {
      case ItemType.MUSICALBUM:
        return ListMusicItem(item: item);
      case ItemType.SEASON:
        return ListVideoItem(item: item);
      case ItemType.SERIES:
        return ListCollectionItem(item: item);
      case ItemType.MUSICARTIST:
        return musicArtistItem(item: item);
      case ItemType.PERSON:
        return personItem(item: item);
      default:
        return Container();
    }
  }

  Widget musicArtistItem({required Item item}) {
    return Column(children: [
      ListCollectionItem(
        item: item,
        future: getItems(
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
        future: getItems(
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
        future: getItems(
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
    return getItems(
        parentId: item.id, limit: 100, fields: 'ImageTags', filter: 'IsFolder');
  } else {
    return getShowSeasonEpisode(item.seriesId!, item.id);
  }
}
