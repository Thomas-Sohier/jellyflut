import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/components/list_items.dart';
import 'package:jellyflut/screens/home/components/search/result_card.dart';
import 'package:jellyflut/screens/home/components/search/search_no_results_placeholder.dart';
import 'package:provider/provider.dart';

class SearchResult extends StatefulWidget {
  SearchResult();

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late final SearchProvider searchProvider;
  late final TextEditingController searchController;
  late final List<Item> items;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    searchProvider = SearchProvider();
    searchController = TextEditingController();
    items = [];
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(builder: (context, search, child) {
      if (search.searchResult.values.any((element) => element.isNotEmpty) &&
          search.showResults) {
        return ResultCard(
            searchController: searchController,
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
        return ResultCard(
          searchController: searchController,
          child: const SearchNoResultsPlaceholder(),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  List<Widget> resultRows(Map<String, List<Item>> searchResult) {
    var rows = <Widget>[];
    searchResult.forEach((key, value) => value.isNotEmpty
        ? rows.add(ListItems.fromList(
            category:
                Category(items: value, startIndex: 0, totalRecordCount: 0),
            itemPosterHeight: itemPosterHeight,
            showTitle: true,
            lisType: ListType.POSTER))
        : Container());
    return rows;
  }
}
