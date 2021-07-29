// ignore: unused_import
import 'dart:developer';

import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/epub.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/item.dart';
import 'package:moor/moor.dart';
import 'dart:io' as io;

class EpubReaderPage extends StatefulWidget {
  final Item item;

  const EpubReaderPage({Key? key, required this.item}) : super(key: key);

  @override
  _EpubReaderPageState createState() => _EpubReaderPageState();
}

class _EpubReaderPageState extends State<EpubReaderPage> {
  late EpubController _epubReaderController;

  @override
  void initState() {
    final loadedBook = _loadFromItem(widget.item);
    _epubReaderController = EpubController(
      document: EpubReader.readBook(loadedBook),
      //     'epubcfi(/6/6[chapter-2]!/4/2/1612)', // book_2.epub Chapter 16 paragraph 3
    );
    super.initState();
  }

  @override
  void dispose() {
    _epubReaderController.dispose();
    super.dispose();
  }

  Future<Uint8List> _loadFromItem(Item item) async {
    var path = await getEbook(item);
    return io.File(path).readAsBytes();
  }

  Future<String> getEbook(Item item) async {
    // Check if we have rights
    // If not we cancel
    var hasStorage = await requestStorage();
    if (!hasStorage) {
      throw ('Cannot access storage');
    }

    // Check if ebook is already present
    if (await isEbookDownloaded(item)) {
      return getStoragePathItem(item);
    }

    var queryParams = <String, dynamic>{};
    queryParams['api_key'] = apiKey;

    var url = '${server.url}/Items/${item.id}/Download?api_key=$apiKey';

    var dowloadPath = await getStoragePathItem(item);
    await downloadFile(url, dowloadPath);
    return dowloadPath;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: EpubActualChapter(
            controller: _epubReaderController,
            builder: (chapterValue) => Text(
              (chapterValue?.chapter?.Title?.trim() ?? '').replaceAll('\n', ''),
              textAlign: TextAlign.start,
            ),
          ),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.save_alt),
          //     color: Colors.white,
          //     onPressed: () => _showCurrentEpubCfi(context),
          //   ),
          // ],
        ),
        drawer: Drawer(
          child: EpubReaderTableOfContents(controller: _epubReaderController),
        ),
        body: EpubView(
          controller: _epubReaderController,
          onDocumentLoaded: (document) {
            print('isLoaded: $document');
          },
          dividerBuilder: (_) => Divider(),
        ),
      );

  // void _showCurrentEpubCfi(context) {
  //   final cfi = _epubReaderController.generateEpubCfi();

  //   if (cfi != null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(cfi),
  //         action: SnackBarAction(
  //           label: 'GO',
  //           onPressed: () {
  //             _epubReaderController.gotoEpubCfi(cfi);
  //           },
  //         ),
  //       ),
  //     );
  //   }
  // }
}
