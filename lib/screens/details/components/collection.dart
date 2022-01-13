import 'package:flutter/material.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/list_person_item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tabs_items.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/extensions/enum_extensions.dart';

class Collection extends StatefulWidget {
  final Item item;
  final List<Item> seasons;
  final TabController? tabController;

  const Collection(this.item,
      {this.tabController, this.seasons = const <Item>[]});

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
      child: showCollection(),
    );
  }

  Widget showCollection() {
    switch (widget.item.type) {
      case ItemType.MUSICALBUM:
        return ListItems.fromFuture(
            itemsFuture: musicFuture,
            showSorting: false,
            verticalListPosterHeight: 150,
            listType: ListType.LIST,
            physics: NeverScrollableScrollPhysics());
      case ItemType.SEASON:
        return ListItems.fromFuture(
            itemsFuture: episodesFuture,
            showSorting: false,
            verticalListPosterHeight: 150,
            listType: ListType.LIST,
            physics: NeverScrollableScrollPhysics());
      case ItemType.SERIES:
        return TabsItems(
            items: widget.seasons, tabController: widget.tabController);
      case ItemType.MUSICARTIST:
        return ListItems.fromFuture(
            itemsFuture: musicAlbumFuture,
            showSorting: false,
            listType: ListType.POSTER);
      case ItemType.PERSON:
        return ListPersonItem(item: widget.item);
      default:
        return const SizedBox();
    }
  }
}
