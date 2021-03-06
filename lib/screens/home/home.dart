import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/provider/searchProvider.dart';
import 'package:jellyflut/screens/home/SearchButton.dart';
import 'package:jellyflut/screens/home/SettingsButton.dart';
import 'package:jellyflut/screens/home/collectionHome.dart';
import 'package:jellyflut/screens/home/resume.dart';
import 'package:jellyflut/screens/home/searchResult.dart';
import 'package:provider/provider.dart';

import 'background.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  SearchProvider searchResult = SearchProvider();

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    return ChangeNotifierProvider.value(
        value: searchResult,
        child: MusicPlayerFAB(
          child: Scaffold(
              extendBody: true,
              backgroundColor: Colors.transparent,
              body: Background(
                  child: RefreshIndicator(
                      onRefresh: () => _refreshItems(),
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                              child: SizedBox(height: statusBarHeight + 10)),
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
                          FutureBuilder<Category>(
                            future: getCategory(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data.items != null) {
                                return buildCategory(snapshot.data);
                              } else if (snapshot.hasError) {
                                return noConnectivity(snapshot.error);
                              }
                              return SliverToBoxAdapter(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ],
                      )))),
        ));
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
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
        ),
        Spacer(),
        SearchButton(),
        SettingsButton(),
        userIcon()
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

  Widget userIcon() {
    return Padding(
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          child: CachedNetworkImage(
            imageUrl:
                '${server.url}/Users/${userJellyfin.id}/Images/Primary?quality=90',
            width: 28,
          ),
        ));
  }

  Widget buildCategory(Category category) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      var _item = category.items[index];
      return CollectionHome(_item);
    }, childCount: category.items.length));
  }

  Future<Null> _refreshItems() async {
    setState(() {});
  }
}
