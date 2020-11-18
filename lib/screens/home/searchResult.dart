import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/searchProvider.dart';
import 'package:provider/provider.dart';

class SearchResult extends StatefulWidget {
  SearchResult();

  @override
  _SearchResultState createState() => _SearchResultState();
}

TextEditingController searchController = TextEditingController();
bool _visibleSearchBar = true;
final _focusNode = FocusNode();

class _SearchResultState extends State<SearchResult> {
  var searchProvider = SearchProvider();
  var items;

  @override
  void initState() {
    super.initState();
    // searchBarListener();
  }

  @override
  void dispose() {
    // _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _focusNode.requestFocus();
    return ChangeNotifierProvider.value(
        value: searchProvider,
        child: Consumer<SearchProvider>(builder: (context, search, child) {
          if (search.searchResult.values.any((element) => element.isNotEmpty) &&
              search.showResults) {
            return resultCard(
                child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: resultRows(search.searchResult),
                    )));
          } else if (search.searchResult.values
                  .every((element) => element.isEmpty) &&
              search.showResults) {
            return resultCard(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      Icon(
                        Icons.movie,
                        size: 42,
                      ),
                      Text(
                        'No results...',
                        style: TextStyle(fontSize: 18),
                      )
                    ])));
          } else {
            return Container();
          }
        }));
  }

  Widget resultCard({@required Widget child}) {
    return Container(
        width: double.maxFinite,
        child: Card(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Column(
              children: [
                Stack(children: [
                  Container(
                      height: 55,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[600],
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      )),
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment.center,
                          child: Visibility(
                              visible: true,
                              child: Row(
                                children: [
                                  Expanded(child: searchContainer()),
                                  clearIcon()
                                ],
                              )))),
                ]),
                // child: Center(
                //   child: Text(
                //     'Your research',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(color: Colors.white, fontSize: 22),
                //   ),
                // ),

                child
              ],
            )));
  }

  Widget searchContainer() {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: Container(
          height: 40,
          width: double.maxFinite,
          padding: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.deepPurple[300].withAlpha(150)),
          child: Row(children: [Expanded(child: searchField()), searchIcon()])),
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
          )),
    );
  }

  Widget clearIcon() {
    return InkWell(
        onTap: () {
          searchController.clear();
          SearchProvider().clearSearchResult();
          if (!_focusNode.hasFocus) {
            setState(() {
              SearchProvider().hideResult();
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

List<Widget> resultRows(Map<String, List<Item>> searchResult) {
  var rows = <Widget>[];
  searchResult.forEach((key, value) => value.isNotEmpty
      ? rows.add(SizedBox(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              key,
              style: TextStyle(color: Colors.black, fontSize: 22),
              textAlign: TextAlign.left,
            ),
            resultListView(value),
          ],
        )))
      : Container());
  return rows;
}

Widget resultListView(List<Item> items) {
  return SizedBox(
      height: 250,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var item = items[index];
            return Padding(
              padding: const EdgeInsets.all(5),
              child: ItemPoster(
                item,
                textColor: Colors.black,
              ),
            );
          }));
}
