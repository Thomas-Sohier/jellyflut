// ignore: unused_import
import 'dart:developer';
import 'dart:typed_data';

import 'package:epubx/epubx.dart' as epubx;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/file/file_service.dart';
import 'package:jellyflut/services/item/ebook_service.dart';
import 'dart:io' as io;
import 'dart:math' as math;

import 'package:jellyflut/shared/shared.dart';
import 'package:simple_html_css/simple_html_css.dart';

class EpubReaderPage extends StatefulWidget {
  final Item item;

  const EpubReaderPage({Key? key, required this.item}) : super(key: key);

  @override
  _EpubReaderPageState createState() => _EpubReaderPageState();
}

class _EpubReaderPageState extends State<EpubReaderPage> {
  late final Future<epubx.EpubBook> epubFuture;
  late final PageController _controller;

  @override
  void initState() {
    final loadedBook = _loadFromItem(widget.item);
    _controller = PageController();
    // Opens a book and reads all of its content into memory
    epubFuture = epubx.EpubReader.readBook(loadedBook);
    RawKeyboard.instance.addListener(_onKey);
    super.initState();
  }

  Future<void> _onKey(RawKeyEvent e) async {
    if (e.runtimeType.toString() == 'RawKeyDownEvent') {
      switch (e.logicalKey.debugName) {
        case 'Arrow Right':
          await _controller.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.easeInExpo);
          break;
        case 'Arrow Left':
          await _controller.previousPage(
              duration: Duration(milliseconds: 500), curve: Curves.easeInExpo);
          break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(widget.item.name)),
      body: FutureBuilder<epubx.EpubBook>(
          future: epubFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final epubBook = snapshot.data!;
              final author = epubBook.Author;
              final authors = epubBook.AuthorList;
              final coverImage = epubBook.CoverImage;
              return Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: PageView.builder(
                        itemCount: epubBook.Content?.Html?.values.length ?? 0,
                        controller: _controller,
                        itemBuilder: (context, index) {
                          final myRichText = HTML.toTextSpan(
                              context,
                              epubBook.Content?.Html?.values
                                      .elementAt(index)
                                      .Content
                                      ?.trim() ??
                                  '',
                              defaultTextStyle:
                                  Theme.of(context).textTheme.bodyText2);
                          return ListView(
                              padding: EdgeInsets.all(16),
                              children: [
                                RichText(
                                  text: myRichText,
                                  textAlign: TextAlign.justify,
                                  softWrap: true,
                                )
                              ]);
                        })),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return Center(child: Text('Ici le livre'));
          }));
}

Uint8List parseEbook(List<int> bytes) {
  return Uint8List.fromList(bytes);
}
