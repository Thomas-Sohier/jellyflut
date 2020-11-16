import 'package:flutter/material.dart';
import 'package:jellyflut/components/itemPoster.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/searchProvider.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:provider/provider.dart';

class SearchResult extends StatefulWidget {
  SearchResult();

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  var searchProvider = SearchProvider();
  var items;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: searchProvider,
        child: Consumer<SearchProvider>(
            builder: (context, search, child) => search.searchResult.isNotEmpty
                ? Column(
                    children: resultRows(search.searchResult),
                  )
                : Container()));
  }
}

List<Widget> resultRows(Map<String, List<Item>> searchResult) {
  var rows = <Widget>[];
  searchResult.forEach((key, value) => value.isNotEmpty
      ? rows.add(SizedBox(
          child: Column(
          children: [
            Text(
              key,
              style: TextStyle(color: Colors.white, fontSize: 22),
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
              child: ItemPoster(item),
            );
          }));
}
