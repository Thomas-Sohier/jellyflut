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
    var size = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
        value: searchResult,
        child: MusicPlayerFAB(
            child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Background(
              child: RefreshIndicator(
                  onRefresh: () => _refreshItems(),
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      SizedBox(height: size.height * 0.05),
                      Stack(children: [
                        SearchResult(),
                        Consumer<SearchProvider>(
                          builder: (context, value, child) {
                            return Visibility(
                                visible: !SearchProvider().showResults,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                      padding:
                                          const EdgeInsets.fromLTRB(6, 0, 0, 0),
                                    ),
                                    Hero(
                                      tag: 'logo_text',
                                      child: Text(
                                        'Jellyfin',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
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
                      SizedBox(height: size.height * 0.03),
                      Resume(),
                      FutureBuilder<Category>(
                        future: getCategory(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return buildCategory(snapshot.data);
                          } else {
                            return Container();
                          }
                        },
                      ),
                      SizedBox(height: size.height * 0.05),
                    ],
                  )))),
        )));
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
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        itemCount: category.items.length,
        itemBuilder: (context, index) {
          var _item = category.items[index];
          return CollectionHome(_item);
        });
  }

  Future<Null> _refreshItems() async {
    setState(() {});
  }
}
