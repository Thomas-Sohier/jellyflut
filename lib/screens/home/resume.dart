import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/components/skeleton.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';

class Resume extends StatelessWidget {
  @override
  Widget build(Object context) {
    return FutureBuilder<Category>(
        future: getResumeItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var _items = snapshot.data.items;
            if (_items != null && _items.isNotEmpty) {
              return body(_items);
            } else {
              return Container(
                height: 0,
                width: 0,
              );
            }
          }
          return Skeleton(
            height: double.maxFinite,
          );
        });
  }

  Widget body(List<Item> items) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Resume',
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
        ),
        ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 230),
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var _item = items[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: ItemPoster(
                        _item,
                        boxFit: BoxFit.cover,
                      ),
                    );
                  },
                )))
      ],
    );
  }
}
