import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/searchProvider.dart';
import 'package:jellyflut/screens/home/collectionHome.dart';
import 'package:jellyflut/screens/home/resume.dart';
import 'package:jellyflut/screens/home/searchResult.dart';

import 'background.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

TextEditingController searchController = TextEditingController();
bool _visibleSearchBar = false;
final _focusNode = FocusNode();

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    searchBarListener();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Background(
            child: GestureDetector(
                onTap: () {
                  //here
                  FocusScope.of(context).unfocus();
                  TextEditingController().clear();
                },
                child: SingleChildScrollView(
                    child: Material(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: size.height * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Hero(
                                    tag: 'logo',
                                    child: Image(
                                      image:
                                          AssetImage('img/jellyfin_logo.png'),
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
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Stack(
                                    children: [
                                      Visibility(
                                          visible: _visibleSearchBar,
                                          child: searchContainer()),
                                      _visibleSearchBar
                                          ? Positioned.fill(
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: clearIcon()))
                                          : searchIcon()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.03),
                            SearchResult(),
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
                        ))))));
  }

  Widget searchContainer() {
    return Container(
      height: 40,
      width: 200,
      constraints: BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.deepPurple[300].withAlpha(150)),
      child: Padding(
          padding: const EdgeInsets.only(left: 4), child: searchField()),
    );
  }

  Widget searchIcon() {
    return InkWell(
        onTap: () => setState(() {
              _visibleSearchBar = true;
              _focusNode.requestFocus();
            }),
        radius: 60,
        borderRadius: BorderRadius.all(Radius.circular(80)),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.search,
            color: Colors.white,
            size: 28,
          ),
        ));
  }

  Widget clearIcon() {
    return InkWell(
        onTap: () {
          searchController.clear();
          SearchProvider().clearSearchResult();
          if (!_focusNode.hasFocus) {
            setState(() {
              _visibleSearchBar = false;
            });
          }
        },
        radius: 60,
        borderRadius: BorderRadius.all(Radius.circular(80)),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.highlight_remove,
            color: Colors.white,
            size: 28,
          ),
        ));
  }
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

void searchBarListener() {
  _focusNode.addListener(() {
    if (!_focusNode.hasFocus &&
        (searchController.value.text == null ||
            searchController.value.text == '')) {
      _visibleSearchBar = false;
    }
  });
}

Widget searchField() {
  return TextFormField(
    maxLines: 1,
    minLines: 1,
    onFieldSubmitted: (value) => searchItemsFuture(value),
    textAlignVertical: TextAlignVertical.center,
    cursorColor: Colors.white,
    controller: searchController,
    focusNode: _focusNode,
    style: TextStyle(color: Colors.white, fontSize: 16),
    decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
        hintText: 'Research',
        fillColor: Colors.white,
        hintStyle: TextStyle(color: Colors.white30, fontSize: 16)),
  );
}

void searchItemsFuture(String value) {
  var results = Map<String, List<Item>>();
  searchItems(searchTerm: value, includeItemTypes: 'Movie').then((value) {
    results.putIfAbsent('Movie', () => value.items);
    SearchProvider().addSearchResult(results);
  });
  searchItems(searchTerm: value, includeItemTypes: 'Series').then((value) {
    results.putIfAbsent('Series', () => value.items);
    SearchProvider().addSearchResult(results);
  });
  searchItems(searchTerm: value, includeItemTypes: 'Episode').then((value) {
    results.putIfAbsent('Episode', () => value.items);
    SearchProvider().addSearchResult(results);
  });
  searchItems(searchTerm: value, includeItemTypes: 'LiveTvProgram')
      .then((value) {
    results.putIfAbsent('LiveTvProgram', () => value.items);
    SearchProvider().addSearchResult(results);
  });
  searchItems(
          searchTerm: value,
          includeItemTypes: 'Movie,Episode',
          mediaTypes: 'Video')
      .then((value) {
    results.putIfAbsent('Movie,Episode', () => value.items);
    SearchProvider().addSearchResult(results);
  });
}
