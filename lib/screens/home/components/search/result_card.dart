import 'package:flutter/material.dart';

import 'clear_icon.dart';
import 'search_field.dart';
import 'search_icon.dart';

class ResultCard extends StatelessWidget {
  final Widget child;
  final TextEditingController searchController;

  const ResultCard(
      {Key? key, required this.child, required this.searchController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey[800],
        margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 65,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[600],
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: Row(
                  children: [
                    Expanded(child: searchField()),
                    SearchIcon(),
                    ClearIcon(searchController: searchController)
                  ],
                )),
            child
          ],
        ));
  }

  Widget searchField() {
    return Container(
        height: 45,
        margin: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: Colors.deepPurple.shade400),
        child: const SearchField());
  }
}
