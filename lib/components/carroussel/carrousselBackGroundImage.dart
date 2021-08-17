import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/items/carrousselProvider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CarrousselBackGroundImage extends StatefulWidget {
  CarrousselBackGroundImage({Key? key}) : super(key: key);

  @override
  _CarrousselBackGroundImageState createState() =>
      _CarrousselBackGroundImageState();
}

class _CarrousselBackGroundImageState extends State<CarrousselBackGroundImage> {
  late final Future<Item> itemFuture;
  late final carrousselProvider;

  @override
  void initState() {
    carrousselProvider = CarrousselProvider();
    itemFuture = getItem(carrousselProvider.itemId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<CarrousselProvider>(
        builder: (context, carrousselProvider, child) {
      if (carrousselProvider.itemId != null) {
        return Container(
          height: size.height,
          width: size.width,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black54,
                Colors.black54,
                Colors.black
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.5, 0.5, 1],
            ),
          ),
          child: FutureBuilder<Item>(
              future: getItem(carrousselProvider.itemId!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return responsiveBackgroundBuilder(snapshot.data!);
                }
                return Container();
              }),
        );
      } else {
        return Container();
      }
    });
  }

  Widget responsiveBackgroundBuilder(Item item) {
    return OrientationLayoutBuilder(
      portrait: (context) => portraitBackground(item),
      landscape: (context) => largeBackground(item),
    );
  }

  Widget portraitBackground(Item item) {
    return AsyncImage(
      item.id,
      item.imageTags!.primary!,
      item.imageBlurHashes!,
      tag: 'Primary',
      boxFit: BoxFit.fitHeight,
    );
  }

  Widget largeBackground(Item item) {
    return AsyncImage(
      item.id,
      item.imageTags!.primary!,
      item.imageBlurHashes!,
      tag: 'Backdrop',
      boxFit: BoxFit.cover,
    );
  }
}
