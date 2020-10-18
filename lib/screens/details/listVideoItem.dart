import 'package:flutter/material.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/components/viewedButton.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';

import '../../main.dart';

class ListVideoItem extends StatelessWidget {
  final Category category;

  const ListVideoItem(this.category);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Container(
            child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: category.items == null ? 0 : category.items.length,
          itemBuilder: (context, index) {
            var item = category.items[index];

            return Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                navigatorKey.currentState
                                    .pushNamed('/details', arguments: item);
                              },
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 10,
                                            child: Text(item.name.trim(),
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: Color(0xFF333333),
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        Spacer(),
                                        actionIcons(item)
                                      ],
                                    ),
                                    if (item.runTimeTicks != null)
                                      Text(
                                          printDuration(Duration(
                                              microseconds:
                                                  (item.runTimeTicks / 10)
                                                      .round())),
                                          style: TextStyle(
                                              color: Colors.grey[700])),
                                    Text((item.overview ?? ''),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(0xFF333333))),
                                  ]))),
                      Container(
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
                              child: GestureDetector(
                                  onTap: () {
                                    navigatorKey.currentState
                                        .pushNamed('/watch', arguments: item);
                                  },
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    size: 32,
                                    color: Colors.black,
                                  )))),
                    ]));
          },
        )));
  }
}

Widget actionIcons(Item item, {fav = true, view = true}) {
  return Row(
    children: [if (fav) FavButton(item), if (view) ViewedButton(item)],
  );
}
