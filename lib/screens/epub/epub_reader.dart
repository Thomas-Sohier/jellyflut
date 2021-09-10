// ignore: unused_import
import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epubx/epubx.dart' as epubx;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/book_extensions.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/epub/components/page_epub.dart';
import 'package:jellyflut/services/file/file_service.dart';
import 'package:jellyflut/services/item/ebook_service.dart';
import 'dart:io' as io;

import 'package:octo_image/octo_image.dart';
import 'package:rxdart/subjects.dart';

class EpubReaderPage extends StatefulWidget {
  final Item item;

  const EpubReaderPage({Key? key, required this.item}) : super(key: key);

  @override
  _EpubReaderPageState createState() => _EpubReaderPageState();
}

class _EpubReaderPageState extends State<EpubReaderPage> {
  late final Future<Widget> epubFuture;
  late final PageController _controller;
  late final BehaviorSubject<Map<int, int>> _pageListener;

  @override
  void initState() {
    _controller = PageController();
    _pageListener = BehaviorSubject<Map<int, int>>();
    final loadedBook = _loadFromItem(widget.item);
    final regexString = r'\.[0-9a-z]+$';
    final regExp = RegExp(regexString);
    final matches = regExp.allMatches(widget.item.path ?? '');
    final match = matches.elementAt(0).group(0) ?? '';
    final bookExtension =
        epubx.EnumFromString<BookExtensions>(BookExtensions.values)
            .get(match.substring(1, match.length));
    switch (bookExtension) {
      case BookExtensions.CBZ:
      case BookExtensions.CBR:
        epubFuture = unarchiveAndSave(loadedBook);
        RawKeyboard.instance.addListener(_onKey);
        break;
      default:
        epubFuture = loadEpubAsync(epubx.EpubReader.readBook(loadedBook));
        RawKeyboard.instance.addListener(_onKey);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Widget> loadEpubAsync(Future<epubx.EpubBook> book) async {
    final epubBook = await book;
    final nbPages = epubBook.Content?.Html?.values.length ?? 0;
    return Center(
      child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: PageView.builder(
              itemCount: epubBook.Content?.Html?.values.length ?? 0,
              controller: _controller,
              itemBuilder: (context, index) {
                _pageListener.add({index: nbPages});
                return PageEpub(
                    content: epubBook.Content?.Html?.values.elementAt(index));
              })),
    );
  }

  Future<void> _onKey(RawKeyEvent e) async {
    if (e.runtimeType.toString() == 'RawKeyDownEvent') {
      switch (e.logicalKey.debugName) {
        case 'Arrow Right':
          await _controller.nextPage(
              duration: Duration(milliseconds: 400),
              curve: Curves.fastLinearToSlowEaseIn);
          break;
        case 'Arrow Left':
          await _controller.previousPage(
              duration: Duration(milliseconds: 400),
              curve: Curves.fastLinearToSlowEaseIn);
          break;
      }
    }
  }

  Future<Uint8List> _loadFromItem(Item item) async {
    try {
      final path = await getEbook(item);
      return io.File(path).readAsBytes();
    } catch (e) {
      final response = await EbookService.downloadEpub(item.id);
      if (response != null) {
        return compute(parseEbook, response);
      } else {
        throw ('error, cannot download epub');
      }
    }
  }

  Future<Widget> unarchiveAndSave(FutureOr<List<int>> bytes) async {
    List<int> loadedBytes;
    if (bytes is Future) {
      loadedBytes = await bytes;
    } else {
      loadedBytes = bytes;
    }

    try {
      final archive = ZipDecoder().decodeBytes(loadedBytes, verify: true);
      final nbPage = archive.files.length;
      return Center(
        child: PageView.builder(
            itemCount: nbPage,
            controller: _controller,
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              _pageListener.add({index: nbPage});
              final archiveFile = archive.files.elementAt(index);
              final isFile = archiveFile.isFile;
              if (isFile) {
                final content = archiveFile.rawContent as InputStream;
                return InteractiveViewer(
                  maxScale: 4,
                  minScale: 0.8,
                  child: OctoImage(
                      image: MemoryImage(content.toUint8List()),
                      fadeInDuration: Duration(milliseconds: 300),
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      errorBuilder: (context, _, stacktrace) =>
                          Center(child: Text('Cannot load page')),
                      alignment: Alignment.center),
                );
              }
              return Text(archiveFile.name);
            }),
      );
    } catch (error) {
      print('erreur issou');
      log('erreur issou', level: 3, error: 'Erreur impossible de dezip le cbz');
      return Center(child: Text(error.toString()));
    }
  }

  Future<String> getEbook(Item item) async {
    // Check if we have rights
    // If we do not store epub
    var hasStorage = await FileService.requestStorage();
    if (!hasStorage) {
      throw ('Cannot access storage');
    }

    // Check if ebook is already present
    if (await EbookService.isEbookDownloaded(item)) {
      return FileService.getStoragePathItem(item);
    }

    final queryParams = <String, dynamic>{};
    queryParams['api_key'] = apiKey;
    final url = '${server.url}/Items/${item.id}/Download?api_key=$apiKey';
    final dowloadPath = await FileService.getStoragePathItem(item);
    await FileService.downloadFileAndSaveToPath(url, dowloadPath);
    return dowloadPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.item.name,
                style: Theme.of(context).textTheme.headline5),
            actions: [pageCounter()]),
        extendBodyBehindAppBar: false,
        extendBody: false,
        body: FutureBuilder<Widget>(
            future: epubFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              return Center(
                  child: Poster(
                      tag: ImageType.PRIMARY,
                      heroTag: null,
                      clickable: false,
                      boxFit: BoxFit.contain,
                      item: widget.item));
            }));
  }

  Widget pageCounter() {
    return StreamBuilder<Map<int, int>>(
      stream: _pageListener,
      initialData: {0: 0},
      builder: (context, snapshot) => PopupMenuButton(
          initialValue: snapshot.data?.values.first ?? 0,
          onSelected: (int pageSelected) => _controller.animateToPage(
              pageSelected,
              duration: Duration(milliseconds: 400),
              curve: Curves.elasticIn),
          itemBuilder: (context) => _pagesListTile(
              snapshot.data?.keys.first ?? 0, snapshot.data?.values.first ?? 0),
          child: pageCounterSelector(snapshot.data?.keys.first ?? 0,
              snapshot.data?.values.first ?? 0)),
    );
  }

  Widget pageCounterSelector(int currentPage, int nbPages) {
    return Container(
      height: double.maxFinite,
      width: 50,
      decoration: BoxDecoration(color: Theme.of(context).accentColor),
      child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Text('$currentPage',
                maxLines: 1,
                style: TextStyle(color: Theme.of(context).primaryColor)),
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
              height: 1,
              color: Theme.of(context).primaryColor,
            ),
            Text('$nbPages',
                maxLines: 1,
                style: TextStyle(color: Theme.of(context).primaryColor))
          ])),
    );
  }

  List<PopupMenuEntry<int>> _pagesListTile(int currentPage, int nbPages) {
    final list = <PopupMenuEntry<int>>[];
    list.add(
      PopupMenuItem(
        child: Text('Select a page'),
      ),
    );
    list.add(
      PopupMenuDivider(
        height: 10,
      ),
    );
    if (nbPages == 0) {
      list.add(PopupMenuItem(enabled: false, child: Text('No pages')));
      return list;
    }
    for (var page = 0; page < nbPages; page++) {
      list.add(
        CheckedPopupMenuItem(
          value: page,
          checked: page == currentPage,
          child: Text('Page n°$page'),
        ),
      );
    }
    return list;
  }
}

Uint8List parseEbook(List<int> bytes) {
  return Uint8List.fromList(bytes);
}
