import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';

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
    return FutureBuilder<Category>(
      future: getCategory(parentId: widget?.item?.id, limit: 10),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => navigatorKey.currentState
                      .pushNamed("/collection", arguments: widget.item),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      widget.item.name,
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 230, minHeight: 230),
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: displayItems(snapshot.data),
                    ))
              ]);
        } else {
          return Container();
        }
      },
    );
  }

  List<Widget> displayItems(Category category) {
    List<Widget> latestMedia = new List<Widget>();
    category?.items?.forEach((Item item) {
      String key = item.imageBlurHashes.primary?.keys?.first;
      latestMedia.add(Container(
        width: 10,
      ));
      latestMedia.add(Container(
        constraints: BoxConstraints(maxWidth: 150),
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed("/details", arguments: item);
                },
                child: AspectRatio(
                    aspectRatio: _aspectRatio(widget.item.collectionType),
                    child: Hero(
                        tag: "poster-${item.id}",
                        child: AsyncImage(item, item.imageBlurHashes)))),
            Text(
              item.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
      ));
    });
    return latestMedia;
  }

  fallbackBlurHash(Map<String, dynamic> bhPrimary, {String key}) {
    if (key == null) {
      key = bhPrimary.keys.first;
    }
    if (bhPrimary != null || key != null) {
      return bhPrimary[key];
    }
    return "";
  }

  double _aspectRatio(String type) {
    if (type == "music") {
      return 1 / 1;
    }
    return 3 / 4;
  }
}
