import 'package:flutter/material.dart';
import 'package:jellyflut/components/favButton.dart';
import 'package:jellyflut/components/viewedButton.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/services/item/itemService.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';

class ListVideoItem extends StatefulWidget {
  final Item item;

  const ListVideoItem({required this.item});

  @override
  _ListVideoItemState createState() => _ListVideoItemState();
}

class _ListVideoItemState extends State<ListVideoItem> {
  late final Future<Category> episodeFuture;
  @override
  void initState() {
    episodeFuture =
        ItemService.getEpsiode(widget.item.seriesId!, widget.item.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: FutureBuilder<Category>(
            future: episodeFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return body(snapshot.data!);
              }
              return placeholderBody();
            }));
  }

  Widget body(Category category) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: category.items.length,
      itemBuilder: (context, index) {
        var item = category.items[index];
        var heroTag = item.id + Uuid().v4();
        return videoItem(index, context, item, heroTag);
      },
    );
  }

  Widget placeholderBody() {
    return Shimmer.fromColors(
        enabled: shimmerAnimation,
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 16),
                  child: Container(
                    height: 40,
                    width: 20,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 20,
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      Container(
                        height: 20,
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      Container(
                        height: 20,
                        margin: EdgeInsets.only(top: 5),
                        width: double.infinity,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
            );
          },
        ));
  }

  Widget videoItem(int index, BuildContext context, Item item, String heroTag) {
    return Column(children: [
      if (index != 0)
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Divider(
            height: 1,
            color: Colors.grey[500],
          ),
        ),
      InkWell(
        onTap: () =>
            customRouter.push(DetailsRoute(item: item, heroTag: heroTag)),
        child: Hero(
          tag: item.id,
          child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12, left: 6),
                      child: Text(item.indexNumber.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 22,
                          )),
                    ),
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          if (item.isNew())
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                color: Colors.red[700],
                                child: Text('NEW',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))),
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
                                          fontWeight: FontWeight.w600))),
                              Spacer(),
                              actionIcons(item)
                            ],
                          ),
                          if (item.runTimeTicks != null)
                            Text(
                                printDuration(
                                    Duration(microseconds: item.getDuration())),
                                style: TextStyle(color: Colors.grey[700])),
                          Text((item.overview ?? ''),
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Color(0xFF333333))),
                        ])),
                    Container(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 4, 4, 4),
                            child: GestureDetector(
                                onTap: () async {
                                  item.playItem();
                                },
                                child: Icon(
                                  Icons.play_circle_outline,
                                  size: 32,
                                  color: Colors.black,
                                )))),
                  ])),
        ),
      )
    ]);
  }

  Widget actionIcons(Item item, {fav = true, view = true}) {
    return Row(
      children: [
        if (fav)
          FavButton(
            item,
            padding: EdgeInsets.only(left: 8, right: 8),
          ),
        if (view)
          ViewedButton(item, padding: EdgeInsets.only(left: 8, right: 8))
      ],
    );
  }
}
