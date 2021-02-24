import 'package:flutter/material.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/provider/searchProvider.dart';
import 'package:jellyflut/screens/home/collectionHome.dart';
import 'package:jellyflut/screens/home/resume.dart';
import 'package:jellyflut/screens/home/searchResult.dart';
import 'package:jellyflut/screens/settings/settings.dart';
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
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
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
                          SliverPadding(
                              padding: EdgeInsets.only(top: statusBarHeight)),
                          SliverToBoxAdapter(
                            child: Stack(children: [
                              SearchResult(),
                              Consumer<SearchProvider>(
                                builder: (context, value, child) {
                                  return Visibility(
                                      visible: !SearchProvider().showResults,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Hero(
                                              tag: 'logo',
                                              child: Image(
                                                image: AssetImage(
                                                    'img/jellyfin_logo.png'),
                                                width: 40.0,
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                6, 0, 0, 0),
                                          ),
                                          Hero(
                                            tag: 'logo_text',
                                            child: Text(
                                              'Jellyfin',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Spacer(),
                                          searchIcon(),
                                          settingsIcon()
                                        ],
                                      ));
                                },
                              )
                            ]),
                          ),
                          // Resume(),
                          FutureBuilder<Category>(
                            future: getCategory(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data.items != null) {
                                return buildCategory(snapshot.data);
                              } else if (snapshot.hasData &&
                                  snapshot.data.items != null) {
                                return noConnectivity();
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

  Widget searchIcon() {
    return InkWell(
      onTap: () => setState(() {
        SearchProvider().showResult();
      }),
      radius: 60,
      borderRadius: BorderRadius.all(Radius.circular(80)),
      child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.search,
            color: Colors.white,
            size: 28,
          )),
    );
  }

  Widget noConnectivity() {
    return SliverToBoxAdapter(
        child: Container(
      child: Icon(
        Icons.wifi_off,
        color: Colors.white,
        size: 50,
      ),
    ));
  }

  Widget settingsIcon() {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => Settings())),
      radius: 60,
      borderRadius: BorderRadius.all(Radius.circular(80)),
      child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.settings,
            color: Colors.white,
            size: 28,
          )),
    );
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
