import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/show.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/itemType.dart';
import 'package:jellyflut/screens/details/template/small_screens/components/items_collection/listCollectionItem.dart'
    as small;
import 'package:jellyflut/screens/details/template/small_screens/components/items_collection/listMusicItem.dart'
    as small;
import 'package:jellyflut/screens/details/template/small_screens/components/items_collection/listVideoItem.dart'
    as small;
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/listCollectionItem.dart'
    as large;
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/listMusicItem.dart'
    as large;
import 'package:jellyflut/screens/details/template/large_screens/components/items_collection/listVideoItem.dart'
    as large;
import 'package:jellyflut/shared/shared.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../globals.dart';

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
        child: responsiveBuilder(),
      ),
    );
  }

  Widget responsiveBuilder() {
    return ScreenTypeLayout.builder(
        breakpoints: screenBreakpoints,
        mobile: (BuildContext context) => showPhoneCollection(),
        tablet: (BuildContext context) => showLargeCollection(),
        desktop: (BuildContext context) => showLargeCollection());
  }

  Widget showPhoneCollection() {
    switch (widget.item.type) {
      case ItemType.MUSICALBUM:
        return small.ListMusicItem(item: widget.item);
      case ItemType.SEASON:
        return small.ListVideoItem(item: widget.item);
      case ItemType.SERIES:
        return small.ListCollectionItem(item: widget.item);
      case ItemType.MUSICARTIST:
        return musicArtistItem(item: widget.item);
      case ItemType.PERSON:
        return personItem(item: widget.item);
      default:
        return Container();
    }
  }

  Widget showLargeCollection() {
    switch (widget.item.type) {
      case ItemType.MUSICALBUM:
        return large.ListMusicItem(item: widget.item);
      case ItemType.SEASON:
        return large.ListVideoItem(item: widget.item);
      case ItemType.SERIES:
        return large.ListCollectionItem(item: widget.item);
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
      small.ListCollectionItem(
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
      small.ListCollectionItem(
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
      small.ListCollectionItem(
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
