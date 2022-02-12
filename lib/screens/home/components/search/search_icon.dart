import 'package:flutter/material.dart';
import 'package:jellyflut/screens/home/components/search/search_rest_call.dart';

class SearchIcon extends StatelessWidget {
  final TextEditingController textEditingController;
  const SearchIcon({Key? key, required this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () => searchItemsFuture(textEditingController.text),
    );
  }
}
