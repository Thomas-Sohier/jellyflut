import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/show.dart';
import 'package:jellyflut/components/carroussel/carroussel.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';

class ListCollectionItem extends StatelessWidget {
  final Item item;

  const ListCollectionItem({@required this.item});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: getItems(item.id,
            limit: 100, fields: 'ImageTags', filter: 'IsFolder'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: CarousselItem(
                    snapshot.data.items,
                    textColor: Colors.white,
                  ),
                ));
          }
          return Container();
        });
  }
}
