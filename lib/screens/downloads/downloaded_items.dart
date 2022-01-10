import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class DownloadedItems extends StatelessWidget {
  final CollectionBloc collectionBloc;
  final Stream<List<Download>> downloads;
  const DownloadedItems(
      {Key? key, required this.collectionBloc, required this.downloads})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Download>>(
        stream: downloads,
        builder: (c, snapshot) {
          final items = snapshot.data != null
              ? snapshot.data!
                  .map((element) => Item.fromMap(element.item!))
                  .toList()
              : <Item>[];
          collectionBloc.add(ClearItem());
          collectionBloc.add(AddItem(items: items));
          final category = Category(
              items: items, totalRecordCount: items.length, startIndex: 0);
          return ListItems.fromList(
              collectionBloc: collectionBloc,
              category: category,
              verticalListPosterHeight: 250,
              listType: ListType.GRID);
        });
  }
}
