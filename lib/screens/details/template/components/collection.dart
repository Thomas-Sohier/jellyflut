import 'package:flutter/material.dart' hide Tab;
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/list_person_item.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/tab.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

// TODO rework this to return Sliver
// Sliver will have better performance while scrolling
// Espacially on details page where some seasons can have a huge number
// of epsiodes
// If this too much work then we should replicate it to sliver and have both options

const double gapSize = 20;

class Collection extends StatelessWidget {
  final Item item;
  final List<Item> seasons;

  const Collection(this.item, {this.seasons = const <Item>[]});
  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case ItemType.MusicAlbum:
        return ListItems.fromItem(
            parentItem: item,
            showSorting: false,
            verticalListPosterHeight: 150,
            listType: ListType.list,
            physics: NeverScrollableScrollPhysics());
      case ItemType.Season:
        return ListItems.fromList(
            items: seasons,
            showSorting: false,
            verticalListPosterHeight: 150,
            listType: ListType.list,
            physics: NeverScrollableScrollPhysics());
      case ItemType.Series:
        return const Tab();
      case ItemType.MusicArtist:
        return ListItems.fromItem(parentItem: item, showSorting: false, listType: ListType.poster);
      case ItemType.Person:
        return ListPersonItem(item: item);
      default:
        return const SizedBox();
    }
  }
}
