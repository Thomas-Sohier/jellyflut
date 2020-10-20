import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/components/skeleton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/colors.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';
import 'package:palette_generator/palette_generator.dart';

import 'asyncImage.dart';

class ItemPoster extends StatelessWidget {
  ItemPoster(this.item, {this.textColor = Colors.white});

  final Item item;
  final Color textColor;

  final BoxShadow boxShadowColor1 =
      BoxShadow(blurRadius: 6, color: Colors.black38, spreadRadius: 1);
  final BoxShadow boxShadowColor2 =
      BoxShadow(blurRadius: 6, color: Colors.black54, spreadRadius: 1);

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  // too CPU intesive :sad:
  // Future<void> paletteShadow(Item item) {
  //   return gePalette(getItemImageUrl(item.id, item.imageBlurHashes))
  //       .then((PaletteGenerator paletteGenerator) {
  //     var _color1 = paletteGenerator.colors.elementAt(0);
  //     var _boxShadowColor1 =
  //         BoxShadow(blurRadius: 6, color: _color1, spreadRadius: 1);

  //     var _color2 = paletteGenerator.colors.elementAt(0);
  //     var _boxShadowColor2 =
  //         BoxShadow(blurRadius: 6, color: _color2, spreadRadius: 1);
  //     boxShadowColor1 = _boxShadowColor1;
  //     boxShadowColor2 = _boxShadowColor2;
  //   }).then((_) => true);
  // }

  Widget body(BuildContext context) {
    return GestureDetector(
        onTap: () =>
            Navigator.of(context).pushNamed('/details', arguments: item),
        child: SizedBox(
          width: 150,
          child: Column(children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: aspectRatio(type: item.type),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [boxShadowColor1, boxShadowColor2]),
                  child: Stack(children: [
                    AsyncImage(
                      item.id,
                      item.imageBlurHashes,
                    ),
                    if (item.userData.playbackPositionTicks != null &&
                        item.userData.playbackPositionTicks > 0)
                      Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: 1,
                            heightFactor: 0.03,
                            child: Container(
                              color: Colors.white38,
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: percentDuration(item),
                            heightFactor: 0.03,
                            child: Container(
                              color: color1,
                            ),
                          ),
                        ],
                      ),
                    if (item.userData.played)
                      Positioned(
                          bottom: 5,
                          right: 15,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 12,
                                        color: Colors.black,
                                        spreadRadius: 1)
                                  ]),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                              ))),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
              ),
            ),
          ]),
        ));
  }
}

double percentDuration(Item item) {
  return item.userData.playbackPositionTicks / item.runTimeTicks;
}
