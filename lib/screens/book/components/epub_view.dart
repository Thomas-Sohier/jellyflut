import 'package:flutter/widgets.dart';

import 'package:jellyflut/screens/book/components/page_epub.dart';
import 'package:shu_epub/shu_epub.dart';

class EpubView extends StatelessWidget {
  final PageController controller;
  final EpubDetails epubDetails;
  final Function(int currentPage, int nbPage) listener;
  const EpubView({super.key, required this.controller, required this.epubDetails, required this.listener});

  @override
  Widget build(BuildContext context) {
    final nbPages = epubDetails.package?.manifest?.items.length ?? 0;
    final manifestItems = epubDetails.package?.manifest?.items ?? [];

    return Center(
      child: AspectRatio(
          aspectRatio: 2 / 3,
          child: PageView.builder(
              itemCount: nbPages,
              controller: controller,
              onPageChanged: (value) => listener(value, nbPages),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return PageEpub(content: manifestItems[index].href ?? '');
              })),
    );
  }
}
