import 'package:flutter/material.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/list_collection_item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/list_person_item.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';

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
            includeItemTypes: ItemType.MUSICALBUM.getValue(),
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
        return ListItems.fromFuture(
            itemsFuture: musicFuture,
            showSorting: false,
            lisType: ListType.LIST,
            itemPosterHeight: 100,
            physics: NeverScrollableScrollPhysics());
      case ItemType.SEASON:
        return ListItems.fromFuture(
            itemsFuture: episodesFuture,
            showSorting: false,
            itemPosterHeight: 150,
            lisType: ListType.LIST,
            physics: NeverScrollableScrollPhysics());
      case ItemType.SERIES:
        return ListCollectionItem(item: widget.item);
      case ItemType.MUSICARTIST:
        return ListItems.fromFuture(
            itemsFuture: musicAlbumFuture,
            showSorting: false,
            lisType: ListType.POSTER);
      case ItemType.PERSON:
        return ListPersonItem(item: widget.item);
      default:
        return SizedBox();
    }
  }
}
