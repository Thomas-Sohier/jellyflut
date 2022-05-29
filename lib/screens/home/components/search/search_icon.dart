import 'package:flutter/material.dart';
import 'package:jellyflut/screens/home/components/search/search_rest_call.dart';

class SearchIcon extends StatelessWidget {
  final TextEditingController textEditingController;
  const SearchIcon({super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () => searchItemsFuture(textEditingController.text),
    );
  }
}
