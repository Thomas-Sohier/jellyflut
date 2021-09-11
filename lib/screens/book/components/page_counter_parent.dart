// ignore: unused_import
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/screens/book/components/page_counter.dart';

class PageCounterParent extends StatelessWidget {
  final Stream<Map<int, int>> streamPage;
  final PageController controller;
  final bool clickable;
  const PageCounterParent(
      {Key? key,
      required this.streamPage,
      required this.controller,
      this.clickable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<int, int>>(
      stream: streamPage,
      builder: (context, snapshot) => PopupMenuButton(
          enabled: clickable,
          initialValue: snapshot.data?.values.first ?? 0,
          onSelected: (int pageSelected) => controller.animateToPage(
              pageSelected,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut),
          itemBuilder: (context) => _pagesListTile(
              snapshot.data?.keys.first ?? 0, snapshot.data?.values.first ?? 0),
          child: PageCounter(
              currentPage: snapshot.data?.keys.first,
              nbPages: snapshot.data?.values.first)),
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
