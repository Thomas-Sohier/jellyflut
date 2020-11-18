import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/listOfItems.dart';
import 'package:jellyflut/shared/shared.dart';
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
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ListOfItems()),
    ], child: buildAllCategory());
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
                GestureDetector(
                  onTap: () => navigatorKey.currentState
                      .pushNamed('/collection', arguments: widget.item),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      widget.item.name,
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
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
              padding: const EdgeInsets.all(5),
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
