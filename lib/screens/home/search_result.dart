import 'package:flutter/material.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:provider/provider.dart';

class SearchResult extends StatefulWidget {
  SearchResult();

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  var searchProvider = SearchProvider();
  var items;
  late TextEditingController _searchController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _searchController = TextEditingController();
    // searchBarListener();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Consumer<SearchProvider>(builder: (context, search, child) {
              if (search.searchResult.values
                      .any((element) => element.isNotEmpty) &&
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
                    child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(children: [
                        Icon(
                          Icons.movie,
                          size: 42,
                          color: Colors.white,
                        ),
                        Text(
                          'No results...',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        )
                      ])),
                ));
              } else {
                return Container();
              }
            })));
  }

  Widget resultCard({required Widget child}) {
    return Container(
        width: double.maxFinite,
        child: Card(
            color: Colors.grey[800],
            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
              color: Colors.deepPurple[300]!.withAlpha(150)),
          child: Row(children: [Expanded(child: searchField()), searchIcon()])),
    );
  }

  Widget searchIcon() {
    return InkWell(
      onTap: () => setState(() {
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
          _searchController.clear();
          searchProvider.clearSearchResult();
          if (!_focusNode.hasFocus) {
            setState(() {
              searchProvider.hideResult();
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

  Widget searchField() {
    return TextFormField(
      maxLines: 1,
      minLines: 1,
      onFieldSubmitted: (value) => searchItemsFuture(value),
      textAlignVertical: TextAlignVertical.center,
      cursorColor: Colors.white,
      controller: _searchController,
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
    var results = <String, List<Item>>{};
    ItemService.searchItems(searchTerm: value, includeItemTypes: 'Movie')
        .then((value) {
      results.putIfAbsent('Movie', () => value.items);
      searchProvider.addSearchResult(results);
    });
    ItemService.searchItems(searchTerm: value, includeItemTypes: 'Series')
        .then((value) {
      results.putIfAbsent('Series', () => value.items);
      searchProvider.addSearchResult(results);
    });
    ItemService.searchItems(searchTerm: value, includeItemTypes: 'Episode')
        .then((value) {
      results.putIfAbsent('Episode', () => value.items);
      searchProvider.addSearchResult(results);
    });
    ItemService.searchItems(
            searchTerm: value, includeItemTypes: 'LiveTvProgram')
        .then((value) {
      results.putIfAbsent('LiveTvProgram', () => value.items);
      searchProvider.addSearchResult(results);
    });
    ItemService.searchItems(
            searchTerm: value,
            includeItemTypes: 'Movie,Episode',
            mediaTypes: 'Video')
        .then((value) {
      results.putIfAbsent('Movie,Episode', () => value.items);
      searchProvider.addSearchResult(results);
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  key,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                  textAlign: TextAlign.left,
                ),
              ),
              resultListView(value),
            ],
          )))
        : Container());
    return rows;
  }

  Widget resultListView(List<Item> items) {
    return SizedBox(
        height: 150,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var item = items[index];
              return Padding(
                padding: const EdgeInsets.all(4),
                child: ItemPoster(
                  item,
                  textColor: Colors.white,
                ),
              );
            }));
  }
}
