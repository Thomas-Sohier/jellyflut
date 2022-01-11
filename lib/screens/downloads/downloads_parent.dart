import 'package:flutter/material.dart';
import 'package:jellyflut/components/list_items/bloc/collection_bloc.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/models/downloads/item_download.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/downloads/current_downloads_list.dart';
import 'package:jellyflut/screens/downloads/downloaded_items.dart';

class DownloadsParent extends StatefulWidget {
  DownloadsParent({Key? key}) : super(key: key);

  @override
  _DownloadsParentState createState() => _DownloadsParentState();
}

class _DownloadsParentState extends State<DownloadsParent> {
  late final Stream<List<Download>> downloadedItems;
  late final List<ItemDownload> currentdownloads;
  late final Database db;
  late final CollectionBloc collectionBloc;

  @override
  void initState() {
    super.initState();
    db = AppDatabase().getDatabase;
    downloadedItems = db.downloadsDao.watchAllDownloads;
    collectionBloc = CollectionBloc(
        listType: ListType.GRID, loadMoreFunction: _defaultLoadMore);
  }

  static Future<Category> _defaultLoadMore(int i, int l) {
    return Future.value(
        Category(items: <Item>[], startIndex: 0, totalRecordCount: 0));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Saved items'),
                    Tab(text: 'Active downloads')
                  ],
                )),
            body: TabBarView(
              children: [
                DownloadedItems(
                    collectionBloc: collectionBloc, downloads: downloadedItems),
                CurrentDownloadList()
              ],
            )));
  }
}
