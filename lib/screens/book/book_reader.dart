// ignore: unused_import
import 'dart:async';
import 'dart:developer';

import 'package:archive/archive.dart';
import 'package:downloads_repository/downloads_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:logging/logging.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/screens/book/bloc/book_bloc.dart';
import 'package:jellyflut/screens/book/compact_book_view.dart';
import 'package:jellyflut/screens/book/components/comic_view.dart';
import 'package:jellyflut/screens/book/components/epub_view.dart';
import 'package:jellyflut/screens/book/util/book_utils.dart';

import 'package:rxdart/subjects.dart';
import 'package:shu_epub/shu_epub.dart';

class BookReaderPage extends StatefulWidget {
  final Item item;

  const BookReaderPage({super.key, required this.item});

  @override
  State<BookReaderPage> createState() => _BookReaderPageState();
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
    final book = context.read<DownloadsRepository>().downloadItem(itemId: item.id);
    // BookUtils.loadItemBook(widget.item);
    constructView(book).catchError((error) {
      log('cannot_open_file'.tr(args: [widget.item.name ?? '']), level: 3, error: 'error_unzip_file'.tr());
      bookBloc.add(BookLoadingError(error.toString()));
    });
    super.initState();
  }

  @override
  void dispose() {
    bookBloc.close();
    _controller.dispose();
    _pageListener.close();
    super.dispose();
  }

  Future<void> constructView(Future<Uint8List> bookFuture) async {
    final book = await bookFuture;
    await context.read<DownloadsRepository>().saveFile(bytes: book, item: item);
    final fileExtension = item.getFileExtension();
    final bookExtension = BookExtensions.fromString(fileExtension);
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
        final epubController = EpubArchiveController(book, enableCache: true);
        final bookView = await constructEpubView(epubController);
        bookBloc.add(BookLoaded(bookView: bookView));
        RawKeyboard.instance.addListener(_onKey);
    }
  }

  Future<void> _onKey(RawKeyEvent e) async {
    if (e.runtimeType.toString() == 'RawKeyDownEvent') {
      switch (e.logicalKey.debugName) {
        case 'Arrow Right':
          await _controller.nextPage(duration: Duration(milliseconds: 400), curve: Curves.fastLinearToSlowEaseIn);
          break;
        case 'Arrow Left':
          await _controller.previousPage(duration: Duration(milliseconds: 400), curve: Curves.fastLinearToSlowEaseIn);
          break;
      }
    }
  }

  void constructComicView(Archive archive) {
    try {
      final comicView = ComicView(
          archive: archive,
          listener: (currentPage, nbPage) => _pageListener.add({currentPage: nbPage}),
          controller: _controller);
      bookBloc.add(BookLoaded(bookView: comicView));
      _pageListener.add({0: archive.length});
    } catch (error) {
      log('cannot_open_file'.tr(args: [widget.item.name ?? '']),
          level: Level.SEVERE.value, error: 'error_unzip_file'.tr());
      bookBloc.add(BookLoadingError(error.toString()));
    }
  }

  Future<Widget> constructEpubView(EpubArchiveController book) async {
    final epubDetails = await book.getEpubDetails();
    _pageListener.add({0: epubDetails?.package?.manifest?.items.length ?? 0});
    return EpubView(
        controller: _controller,
        epubDetails: epubDetails!,
        listener: (currentPage, nbPage) => _pageListener.add({currentPage: nbPage}));
  }

  @override
  Widget build(BuildContext context) {
    return CompactBookView(
        item: item,
        bookBloc: bookBloc,
        pageController: _controller,
        streamPosition: _pageListener,
        listener: (currentPage, nbPage) => _pageListener.add({currentPage: nbPage}));
  }
}
