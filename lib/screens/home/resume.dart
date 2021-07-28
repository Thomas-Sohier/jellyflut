import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:shimmer/shimmer.dart';

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
              return Container();
            }
          }
          return placeholder();
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
        SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                var _item = items[index];
                return ItemPoster(
                  _item,
                  showLogo: true,
                  showParent: false,
                  widgetAspectRatio: 16 / 9,
                );
              },
            ))
      ],
    );
  }

  Widget placeholder() {
    return Shimmer.fromColors(
        enabled: shimmerAnimation,
        highlightColor: Colors.grey[700],
        baseColor: Colors.grey[300],
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                    height: 30,
                    width: 70,
                    color: Colors.white30,
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 3,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 4, 8, 4),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          child: Container(
                                            height: 200,
                                            width: 200 * (2 / 3),
                                            color: Colors.white30,
                                          )))))),
                    ],
                  ))
            ]));
  }
}
