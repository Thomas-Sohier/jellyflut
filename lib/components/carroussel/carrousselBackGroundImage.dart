import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/carrousselModel.dart';
import 'package:provider/provider.dart';

class CarrousselBackGroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<CarrousselModel>(
        builder: (context, carrousselModel, child) {
      if (carrousselModel.itemId != null) {
        return Container(
          height: size.height,
          width: size.width,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black45,
                Colors.black38,
                Colors.black
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.4, 0.7, 1],
            ),
          ),
          child: FutureBuilder<Item>(
              future: getItem(carrousselModel.itemId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return AsyncImage(
                    snapshot.data.id,
                    snapshot.data.imageTags.primary,
                    snapshot.data.imageBlurHashes,
                    tag: 'Primary',
                    boxFit: BoxFit.fitHeight,
                  );
                }
                return Container();
              }),
        );
      } else {
        return Container();
      }
    });
  }
}
