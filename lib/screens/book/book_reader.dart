// ignore: unused_import
import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:epubx/epubx.dart' as epubx;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/models/enum/book_extensions.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/book/bloc/book_bloc.dart';
import 'package:jellyflut/screens/book/compact_book_view.dart';
import 'package:jellyflut/screens/book/components/comic_view.dart';
import 'package:jellyflut/screens/book/components/epub_view.dart';
import 'package:jellyflut/screens/book/large_book_view.dart';
import 'package:jellyflut/screens/book/util/book_utils.dart';
import 'package:jellyflut/shared/responsive_builder.dart';

import 'package:rxdart/subjects.dart';

class BookReaderPage extends StatefulWidget {
  final Item item;

  const BookReaderPage({Key? key, required this.item}) : super(key: key);

  @override
  _BookReaderPageState createState() => _BookReaderPageState();
}

class _BookReaderPageState extends State<BookReaderPage> {
  late final PageController _controller;
  late final BehaviorSubject<Map<int, int>> _pageListener;
  late final BookBloc bookBloc;
  late final Item item;

  @override
  void initState() {
    _controller = PageController();
    _pageListener = BehaviorSubject<Map<int, int>>();
    item = widget.item;
    bookBloc = BookBloc();
    bookBloc.add(BookLoading());
    final book = BookUtils.loadItemBook(widget.item);
    constructView(book);
    super.initState();
  }

  @override
  void dispose() {
    bookBloc.close();
    super.dispose();
  }

  Future<void> constructView(Future<Uint8List> book) async {
    final fileExtension = item.getFileExtension();
    final bookExtension =
        epubx.EnumFromString<BookExtensions>(BookExtensions.values)
            .get(fileExtension!.substring(1, fileExtension.length));
    switch (bookExtension) {
      case BookExtensions.CBA:
      case BookExtensions.CBZ:
      case BookExtensions.CBT:
      case BookExtensions.CBR:
      case BookExtensions.CB7:
        final archive = await BookUtils.unarchive(book);
        constructComicView(archive);
        RawKeyboard.instance.addListener(_onKey);
        break;
      case BookExtensions.EPUB:
      default:
        final epub = await epubx.EpubReader.readBook(book);
        final bookView = await constructEpubView(epub);
        bookBloc.add(BookLoaded(bookView: bookView));
        RawKeyboard.instance.addListener(_onKey);
    }
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

  void constructComicView(Archive archive) {
    try {
      final comicView = ComicView(
          archive: archive,
          listener: (currentPage, nbPage) =>
              _pageListener.add({currentPage: nbPage}),
          controller: _controller);
      bookBloc.add(BookLoaded(bookView: comicView));
      _pageListener.add({0: archive.length});
    } catch (error) {
      log('Cannot open file, ${widget.item.name}',
          level: 3, error: 'Error cannot unzip cbz file');
      bookBloc.add(BookLoadingError(error.toString()));
    }
  }

  Future<Widget> constructEpubView(epubx.EpubBook book) async {
    _pageListener.add({0: book.Content?.Html?.length ?? 0});
    return EpubView(
        controller: _controller,
        epubBook: book,
        listener: (currentPage, nbPage) =>
            _pageListener.add({currentPage: nbPage}));
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder.builder(
        mobile: () => CompactBookView(
            item: item,
            bookBloc: bookBloc,
            pageController: _controller,
            streamPosition: _pageListener,
            listener: (currentPage, nbPage) =>
                _pageListener.add({currentPage: nbPage})),
        tablet: () => CompactBookView(
            item: item,
            bookBloc: bookBloc,
            pageController: _controller,
            streamPosition: _pageListener,
            listener: (currentPage, nbPage) =>
                _pageListener.add({currentPage: nbPage})),
        desktop: () => LargeBookView(
            item: item,
            bookBloc: bookBloc,
            pageController: _controller,
            streamPosition: _pageListener,
            listener: (currentPage, nbPage) =>
                _pageListener.add({currentPage: nbPage})));
  }
}
