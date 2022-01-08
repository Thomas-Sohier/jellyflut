import 'package:flutter/material.dart';

import 'package:jellyflut/providers/search/search_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';

class SearchButton extends StatefulWidget {
  @override
  _SearchButtonState createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  late SearchProvider searchProvider;
  late FocusNode _node;

  @override
  void initState() {
    searchProvider = SearchProvider();
    _node = FocusNode(descendantsAreFocusable: false, skipTraversal: false);
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
          Icons.search,
          color: Colors.white,
          size: 28,
        ));
  }
}
