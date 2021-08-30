import 'package:flutter/material.dart';
import 'package:jellyflut/models/enum/itemType.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
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
        return ListPersonItem(item: widget.item);
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
}
