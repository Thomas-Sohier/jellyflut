import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/models/category.dart';

class Collection extends StatefulWidget {
  final String itemId;
  const Collection(this.itemId);

  @override
  State<StatefulWidget> createState() {
    return _CollectionState();
  }
}

const double gapSize = 20;

class _CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
      future: getItems(widget.itemId, 100),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: displayItems(snapshot.data),
          );
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
      latestMedia.add(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("/details", arguments: item);
              },
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Hero(
                      tag: "poster-${item.id}",
                      child: BlurHash(
                          imageFit: BoxFit.fill,
                          hash: fallbackBlurHash(
                              item.imageBlurHashes.primary, key))))),
          Text(
            item.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 16),
          )
        ],
      ));
    });
    return latestMedia;
  }

  fallbackBlurHash(bhPrimary, key) {
    if (bhPrimary != null || key != null) {
      return bhPrimary[key];
    }
    return "";
  }
}
