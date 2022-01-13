import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class DownloadedItems extends StatefulWidget {
  const DownloadedItems({Key? key}) : super(key: key);

  @override
  _DownloadedItemsState createState() => _DownloadedItemsState();
}

class _DownloadedItemsState extends State<DownloadedItems> {
  late final List<Download> downloadedItems;
  late final Database db;
  late final CollectionBloc collectionBloc;

  @override
  void initState() {
    db = AppDatabase().getDatabase;
    collectionBloc = CollectionBloc(
        listType: ListType.GRID, loadMoreFunction: _defaultLoadMore);
    super.initState();
  }

  static Future<Category> _defaultLoadMore(int i, int l) {
    return Future.value(
        Category(items: <Item>[], startIndex: 0, totalRecordCount: 0));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Download>>(
        stream: db.downloadsDao.watchAllDownloads,
        builder: (c, a) {
          final items = a.data != null
              ? a.data!.map((element) => Item.fromMap(element.item!)).toList()
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
