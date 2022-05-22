import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jellyflut/mixins/home_tab.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/screens/home/home_category.dart';
import 'package:jellyflut/screens/home/latest.dart';
import 'package:jellyflut/screens/home/resume.dart';
import 'package:jellyflut/services/user/user_service.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with HomeTab, TickerProviderStateMixin {
  late final PageController _pageController;
  late final ScrollController _scrollController;
  late SearchProvider searchProvider;
  late Future<Category> categoryFuture;

  @override
  set tabController(TabController _tabController) {
    super.tabController = _tabController;
  }

  @override
  void initState() {
    searchProvider = SearchProvider();
    _scrollController = ScrollController(initialScrollOffset: 0);
    categoryFuture = UserService.getLibraryCategory();
    _pageController = PageController();
    tabController = TabController(length: 0, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return ExcludeFocus(
      excluding: excluding,
      child: CustomScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: statusBarHeight + 10)),
            SliverToBoxAdapter(child: Resume()),
            SliverToBoxAdapter(child: Latest()),
            categoryBuilder()
          ]),
    );
  }

  /// Can show error if any
  Widget categoryBuilder() {
    return FutureBuilder<Category>(
      future: categoryFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          return buildCategory(snapshot.data!);
        } else if (snapshot.hasError) {
          return noConnectivity(SocketException(snapshot.error.toString()));
        }
        return SliverToBoxAdapter();
      },
    );
  }

  Widget noConnectivity(SocketException error) {
    return SliverToBoxAdapter(
        child: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          Icons.wifi_off,
          color: Colors.white,
          size: 50,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            error.message,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        )
      ]),
    ));
  }

  Widget buildCategory(Category category) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      var _item = category.items[index];
      return HomeCategory(_item);
    }, childCount: category.items.length));
  }
}
