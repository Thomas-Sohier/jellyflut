import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:jellyflut/shared/theme.dart';

import 'asyncImage.dart';

class ItemPoster extends StatelessWidget {
  ItemPoster(this.item, {this.textColor = Colors.white});

  final Item item;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () =>
            Navigator.of(context).pushNamed('/details', arguments: item),
        child: SizedBox(
          width: 150,
          child: Column(children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: aspectRatio(type: item.type),
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
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                        )),
                ]),
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
