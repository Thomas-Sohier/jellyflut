import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/components/slideRightRoute.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/listOfItems.dart';
import 'package:jellyflut/screens/collection/collectionMain.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:provider/provider.dart';

class CollectionHome extends StatefulWidget {
  final Item item;
  const CollectionHome(this.item);

  @override
  State<StatefulWidget> createState() {
    return _CollectionHomeState();
  }
}

const double gapSize = 20;

class _CollectionHomeState extends State<CollectionHome> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => ListOfItems()),
      ], child: buildAllCategory()),
    );
  }

  void slideToPageDetail() {
    Navigator.push(
        context,
        SlideRightRoute(
          page: CollectionMain(
            item: widget.item,
          ),
        ));
  }

  Widget buildAllCategory() {
    return FutureBuilder<List<Item>>(
      future: getLatestMedia(
          parentId: widget?.item?.id,
          fields: 'DateCreated, DateAdded, ImageTags'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 25, 5, 5),
                    child: Row(children: [
                      GestureDetector(
                        onTap: () => slideToPageDetail(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 45,
                              height: 5,
                              margin: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                  color: jellyLightPurple,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            Text(
                              widget.item.name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 28),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Icon(Icons.chevron_right_rounded,
                              color: Colors.white, size: 42),
                          onTap: () => slideToPageDetail()),
                    ])),
                SizedBox(
                  height: 200,
                  child: displayItems(snapshot.data),
                )
              ]);
        } else {
          return Container();
        }
      },
    );
  }

  Widget displayItems(List<Item> items) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var _item = items[index];
          return Padding(
              padding: const EdgeInsets.all(8),
              child: AspectRatio(
                aspectRatio: aspectRatio(type: _item.type) - .1,
                child: ItemPoster(
                  _item,
                ),
              ));
        });
  }

  dynamic fallbackBlurHash(Map<String, dynamic> bhPrimary, {String key}) {
    key ??= bhPrimary.keys.first;
    if (bhPrimary != null || key != null) {
      return bhPrimary[key];
    }
    return '';
  }
}
