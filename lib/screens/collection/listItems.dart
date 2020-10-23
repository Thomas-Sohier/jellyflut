import 'package:flutter/material.dart';
import 'package:jellyflut/components/itemPoster.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/listOfItems.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:provider/provider.dart';

class ListItems extends StatelessWidget {
  const ListItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ListOfItems>(
        builder: (context, listOfItems, child) => listOfItems.items.isNotEmpty
            ? buildItemsGrid(listOfItems.items)
            : Container());
  }

  Widget buildItemsGrid(List<Item> items) {
    return Padding(
        padding: EdgeInsets.all(6),
        child: GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: aspectRatio(type: items.first.type),
                mainAxisSpacing: 25,
                crossAxisSpacing: 5),
            itemBuilder: (context, index) {
              return ItemPoster(items[index]);
            }));
  }
}
