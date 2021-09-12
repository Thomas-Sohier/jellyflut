import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/background_image.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:jellyflut/components/detail_header_bar.dart';
import 'package:jellyflut/screens/details/template/left_details.dart';
import 'package:jellyflut/screens/details/template/right_details.dart';
import 'package:jellyflut/screens/details/template/right_details_background.dart';
import 'package:jellyflut/screens/details/template/skeleton_right_details.dart';

class LargeDetails extends StatefulWidget {
  final Item item;
  final Future<Item> itemToLoad;
  final Future<Color> dominantColorFuture;
  final String? heroTag;

  LargeDetails(
      {Key? key,
      required this.item,
      required this.itemToLoad,
      required this.dominantColorFuture,
      this.heroTag})
      : super(key: key);

  @override
  _LargeDetailsState createState() => _LargeDetailsState();
}

class _LargeDetailsState extends State<LargeDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return largeScreenTemplate();
  }

  Widget largeScreenTemplate() {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(
        item: widget.item,
        imageType: ImageType.BACKDROP,
      ),
      Stack(alignment: Alignment.topCenter, children: [
        Column(children: [
          Expanded(
              child: Row(children: [
            SizedBox(
              height: 64,
            ),
            leftDetailsPart(),
            rightDetailsPart()
          ])),
        ]),
        DetailHeaderBar(
          color: Colors.white,
          showDarkGradient: false,
          height: 64,
        )
      ])
    ]);
  }

  Widget leftDetailsPart() {
    return Expanded(
        flex: 4,
        child: LeftDetails(
          item: widget.item,
          heroTag: widget.heroTag,
        ));
  }

  Widget rightDetailsPart() {
    return Expanded(
        flex: 6,
        child: RightDetailsBackground(
            dominantColorFuture: widget.dominantColorFuture,
            child: largeWidgetBuilder()));
  }

  Widget largeWidgetBuilder() {
    final mediaQuery = MediaQuery.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 82, 24, 24),
      children: [
        if (widget.item.hasLogo())
          Logo(item: widget.item, size: mediaQuery.size),
        asyncRightDetails()
      ],
    );
  }

  Widget asyncRightDetails() {
    return FutureBuilder<Item>(
        future: widget.itemToLoad,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RightDetails(
                item: snapshot.data!,
                dominantColorFuture: widget.dominantColorFuture);
          }
          return SkeletonRightDetails();
        });
  }
}
