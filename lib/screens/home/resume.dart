import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/itemPoster.dart';
import 'package:jellyflut/components/skeleton.dart';
import 'package:jellyflut/models/category.dart';

class Resume extends StatelessWidget {
  @override
  Widget build(Object context) {
    return FutureBuilder<Category>(
        future: getResumeItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var _items = snapshot.data.items;
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
                    constraints: BoxConstraints(maxHeight: 250),
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            var _item = _items[index];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: ItemPoster(
                                _item,
                                boxFit: BoxFit.fitWidth,
                              ),
                            );
                          },
                        )))
              ],
            );
          }
          return Skeleton(
            height: double.maxFinite,
          );
        });
  }
}
