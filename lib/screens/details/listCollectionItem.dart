import 'package:flutter/material.dart';
import 'package:jellyflut/components/carroussel.dart';
import 'package:jellyflut/models/category.dart';

class ListCollectionItem extends StatelessWidget {
  final Category category;

  const ListCollectionItem(this.category);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: CarousselItem(
            category.items,
            textColor: Colors.white,
          ),
        ));
  }
}
