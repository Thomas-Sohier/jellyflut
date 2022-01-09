import 'package:flutter/material.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/components/list_items/list_items_parent.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class DownloadsParent extends StatefulWidget {
  DownloadsParent({Key? key}) : super(key: key);

  @override
  _DownloadsParentState createState() => _DownloadsParentState();
}

class _DownloadsParentState extends State<DownloadsParent> {
  late final Stream<List<Download>> downloads;
  late final Database db;
  late final CollectionBloc collectionBloc;

  @override
  void initState() {
    super.initState();
    db = AppDatabase().getDatabase;
    downloads = db.downloadsDao.watchAllDownloads;
    collectionBloc = CollectionBloc(
        listType: ListType.GRID, loadMoreFunction: _defaultLoadMore);
  }

  static Future<Category> _defaultLoadMore(int i, int l) {
    return Future.value(
        Category(items: <Item>[], startIndex: 0, totalRecordCount: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        AppBar(backgroundColor: Colors.transparent, elevation: 0),
        StreamBuilder<List<Download>>(
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
              return Padding(
                padding: const EdgeInsets.only(top: 18),
                child: ListItems.fromList(
                    collectionBloc: collectionBloc,
                    category: category,
                    listType: ListType.GRID),
              );
            }),
      ],
    ));
  }
}
