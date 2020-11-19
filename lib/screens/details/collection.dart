import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/show.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/listCollectionItem.dart';
import 'package:jellyflut/screens/details/listMusicItem.dart';
import 'package:jellyflut/screens/details/listVideoItem.dart';

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
    return SingleChildScrollView(
        child: Column(
      children: [showCollection(widget.item)],
    ));
  }
}

Widget showCollection(Item item) {
  if (item.isFolder != null) {
    if (item.isFolder && item.type == 'MusicAlbum') {
      return ListMusicItem(item: item);
    } else if (item.isFolder && item.type == 'Season') {
      return ListVideoItem(item: item);
    }
    return ListCollectionItem(item: item);
  } else if (item.type == 'MusicArtist') {
    return ListCollectionItem(
      item: item,
      future: getItems(
          includeItemTypes: 'MusicAlbum',
          sortBy: 'ProductionYear,Sortname',
          albumArtistIds: item.id,
          fields:
              'AudioInfo,SeriesInfo,ParentId,PrimaryImageAspectRatio,BasicSyncInfo,AudioInfo,SeriesInfo,ParentId,PrimaryImageAspectRatio,BasicSyncInfo'),
    );
  }
  return Container();
}

Future collectionItems(Item item) {
  // If it's a series or a music album we get every item
  if (item.type == 'Series' || item.type == 'MusicAlbum') {
    return getItems(
        parentId: item.id, limit: 100, fields: 'ImageTags', filter: 'IsFolder');
  } else {
    return getShowSeasonEpisode(item.seriesId, item.id);
  }
}
