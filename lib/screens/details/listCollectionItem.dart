import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:uuid/uuid.dart';

class ListCollectionItem extends StatelessWidget {
  final Item item;
  final String title;
  final Future<Category> future;

  const ListCollectionItem({@required this.item, this.title, this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Category>(
        future: future ??
            getItems(
                parentId: item.id,
                limit: 100,
                fields: 'ImageTags',
                filter: 'IsFolder'),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.items.isNotEmpty) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        title,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                    ),
                  carouselSlider(snapshot.data.items)
                ]);
          }
          return Container();
        });
  }

  Widget carouselSlider(List<Item> items) {
    return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: items.first.getPrimaryAspectRatio(),
            viewportFraction: items.first.getPrimaryAspectRatio() / 2,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            scrollDirection: Axis.horizontal,
            height: 200),
        items: items.map((item) {
          var heroTag = item.id + Uuid().v4();
          return ItemPoster(
            item,
            showParent: false,
            heroTag: heroTag,
          );
        }).toList());
  }
}
