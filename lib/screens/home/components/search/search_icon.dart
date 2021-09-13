import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';

class SearchIcon extends StatefulWidget {
  SearchIcon({Key? key}) : super(key: key);

  @override
  _SearchIconState createState() => _SearchIconState();
}

class _SearchIconState extends State<SearchIcon> {
  late final FocusNode _node;
  late final SearchProvider searchProvider;

  @override
  void initState() {
    _node = FocusNode();
    searchProvider = SearchProvider();
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        node: _node,
        onPressed: searchProvider.showResult,
        shape: CircleBorder(),
        child: Icon(
          Icons.search_outlined,
          color: Colors.white,
          size: 28,
        ));
  }
}
