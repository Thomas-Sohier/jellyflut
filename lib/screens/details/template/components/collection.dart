import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/list_person_item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tabs_items.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

// TODO rework this to return Sliver
// Sliver will have better performance while scrolling
// Espacially on details page where some seasons can have a huge number
// of epsiodes
// If this too much work then we should replicate it to sliver and have both options

class Collection extends StatefulWidget {
  final Item item;
  final List<Item> seasons;

  const Collection(this.item, {this.seasons = const <Item>[]});

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
        musicFuture = context.read<ItemsRepository>().getCategory(parentId: widget.item.id);
        break;
      case ItemType.MUSICARTIST:
        musicAlbumFuture = context.read<ItemsRepository>().getCategory(
            includeItemTypes: ItemType.MUSICALBUM.value,
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
        return TabsItems();
      case ItemType.MUSICARTIST:
        return ListItems.fromFuture(itemsFuture: musicAlbumFuture, showSorting: false, listType: ListType.POSTER);
      case ItemType.PERSON:
        return ListPersonItem(item: widget.item);
      default:
        return const SizedBox();
    }
  }
}
