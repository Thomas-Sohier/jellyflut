import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/show.dart';
import 'package:jellyflut/components/carroussel/carroussel.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';

class ListCollectionItem extends StatelessWidget {
  final Item item;
  final String title;
  final Future<Category> future;

  const ListCollectionItem({@required this.item, this.title, this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: future ??
            getItems(
                parentId: item.id,
                limit: 100,
                fields: 'ImageTags',
                filter: 'IsFolder'),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.items.isNotEmpty) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        title,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    ),
                  ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 300),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: CarousselItem(
                          snapshot.data.items,
                          textColor: Colors.white,
                        ),
                      ))
                ]);
          }
          return Container();
        });
  }
}
