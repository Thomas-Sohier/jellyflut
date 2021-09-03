import 'package:flutter/material.dart';
import 'package:jellyflut/models/enum/itemType.dart';
import 'package:jellyflut/models/enum/listType.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/listItems.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/listPersonItem.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/listCollectionItem.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/listMusicItem.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/listVideoItem.dart';
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
  late final Future<Category> musicAlbumFuture;
  late final Future<Category> episodesFuture;
  late final Future<Category> musicFuture;

  @override
  void initState() {
    super.initState();
    switch (widget.item.type) {
      case ItemType.MUSICALBUM:
        musicFuture = ItemService.getItems(parentId: widget.item.id);
        break;
      case ItemType.SEASON:
        episodesFuture =
            ItemService.getEpsiode(widget.item.seriesId!, widget.item.id);
        break;
      case ItemType.MUSICARTIST:
        musicAlbumFuture = ItemService.getItems(
            includeItemTypes: getEnumValue(ItemType.MUSICALBUM.toString()),
            sortBy: 'ProductionYear,Sortname',
            albumArtistIds: widget.item.id,
            fields:
                'AudioInfo,SeriesInfo,ParentId,PrimaryImageAspectRatio,BasicSyncInfo,AudioInfo,SeriesInfo,ParentId,PrimaryImageAspectRatio,BasicSyncInfo');
        break;
      default:
        break;
    }
  }

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
        return ListItems(
            itemsFuture: musicFuture, lisType: ListType.LIST, itemHeight: 100);
      case ItemType.SEASON:
        return ListItems(
            itemsFuture: episodesFuture,
            itemHeight: 150,
            lisType: ListType.LIST,
            physics: NeverScrollableScrollPhysics());
      case ItemType.SERIES:
        return ListCollectionItem(item: widget.item);
      case ItemType.MUSICARTIST:
        return ListItems(
            itemsFuture: musicAlbumFuture,
            lisType: ListType.POSTER,
            physics: NeverScrollableScrollPhysics());
      case ItemType.PERSON:
        return ListPersonItem(item: widget.item);
      default:
        return SizedBox();
    }
  }
}
