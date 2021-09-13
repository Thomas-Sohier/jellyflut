import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/screens/details/template/components/user_icon.dart';
import 'package:jellyflut/screens/home/search_button.dart';
import 'package:jellyflut/screens/home/settings_button.dart';
import 'package:jellyflut/screens/home/home_categories.dart';
import 'package:jellyflut/screens/home/resume.dart';
import 'package:jellyflut/screens/home/components/search/search_result.dart';
import 'package:jellyflut/services/user/user_service.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  late final PageController _pageController;
  late final ScrollController _scrollController;
  late SearchProvider searchProvider;
  late Future<Category> categoryFuture;

  @override
  void initState() {
    searchProvider = SearchProvider();
    _scrollController = ScrollController();
    categoryFuture = UserService.getLibraryCategory();
    _pageController = PageController();
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
    return ChangeNotifierProvider<SearchProvider>.value(
        value: searchProvider,
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: statusBarHeight + 10)),
            SliverToBoxAdapter(
              child: Stack(children: [
                SearchResult(),
                Consumer<SearchProvider>(
                  builder: (context, value, child) {
                    return Visibility(
                        visible: !SearchProvider().showResults,
                        child: headerBar());
                  },
                )
              ]),
            ),
            SliverToBoxAdapter(child: Resume()),
            categoryBuilder()
          ],
        ));
  }

  /// Prevent from re-query the API on resize
  Widget categoryBuilder() {
    return FutureBuilder<Category>(
      future: categoryFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          return buildCategory(snapshot.data!);
        } else if (snapshot.hasError) {
          return noConnectivity(SocketException(snapshot.error.toString()));
        }
        return SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget headerBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 8,
        ),
        Hero(
            tag: 'logo',
            child: Image(
              image: AssetImage('img/jellyfin_logo.png'),
              width: 40.0,
            )),
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
        ),
        Hero(
          tag: 'logo_text',
          child: Text(
            'Jellyfin',
            style: TextStyle(
                fontSize: 22, color: Colors.white, fontFamily: 'Quicksand'),
          ),
        ),
        Spacer(),
        SearchButton(),
        SettingsButton(),
        UserIcon()
      ],
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
      return HomeCategories(_item);
    }, childCount: category.items.length));
  }
}
