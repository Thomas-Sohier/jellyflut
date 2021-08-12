import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/poster/itemPoster.dart';
import 'package:jellyflut/models/item.dart';

class LeftDetails extends StatelessWidget {
  final Item item;
  final Color color;
  final String heroTag;

  const LeftDetails({
    Key? key,
    required this.item,
    required this.heroTag,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
              decoration: BoxDecoration(color: color.withOpacity(0.8)),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 64, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: ItemPoster(
                        item,
                        clickable: false,
                        heroTag: heroTag,
                        boxFit: BoxFit.contain,
                        showName: false,
                      )),
                    ],
                  )))),
    );
  }
}
