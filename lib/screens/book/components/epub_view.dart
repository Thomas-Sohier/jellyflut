import 'package:epubx/epubx.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/book/components/page_epub.dart';

class EpubView extends StatelessWidget {
  final PageController controller;
  final EpubBook epubBook;
  final Function(int currentPage, int nbPage) listener;
  const EpubView(
      {Key? key,
      required this.controller,
      required this.epubBook,
      required this.listener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nbPages = epubBook.Content?.Html?.values.length ?? 0;
    return Center(
      child: AspectRatio(
          aspectRatio: 2 / 3,
          child: PageView.builder(
              itemCount: nbPages,
              controller: controller,
              onPageChanged: (value) => listener(value, nbPages),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return PageEpub(
                    content: epubBook.Content?.Html?.values.elementAt(index));
              })),
    );
  }
}
