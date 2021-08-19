import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/enum/imageType.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/detailHeaderBar.dart';
import 'package:jellyflut/screens/details/shared/luminance.dart';
import 'package:jellyflut/screens/details/template/large_screens/leftDetails.dart';
import 'package:jellyflut/screens/details/template/large_screens/rightDetails.dart';
import 'package:jellyflut/screens/details/template/large_screens/skeletonRightDetails.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;

import '../../BackgroundImage.dart';

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
          heroTag: widget.heroTag ?? '',
        ));
  }

  Widget rightDetailsPart() {
    return Expanded(
        flex: 6,
        child: ClipRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
                child: FutureBuilder<Color>(
                    future: widget.dominantColorFuture,
                    builder: (context, colorsSnapshot) {
                      if (colorsSnapshot.hasData) {
                        final finalDetailsThemeData =
                            Luminance.computeLuminance(
                                colorsSnapshot.data!.withOpacity(0.4));
                        return Theme(
                            data: finalDetailsThemeData,
                            child: largeWidgetBuilder(finalDetailsThemeData));
                      }
                      return Theme(
                          data: personnal_theme.Theme.defaultThemeData,
                          child: largeWidgetBuilder(
                              personnal_theme.Theme.defaultThemeData));
                    }))));
  }

  Widget largeWidgetBuilder(ThemeData themeData) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                color: themeData.backgroundColor.withOpacity(0.4))),
        FutureBuilder<Item>(
            future: widget.itemToLoad,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return RightDetails(
                  item: snapshot.data!,
                  dominantColorFuture: widget.dominantColorFuture,
                );
              }
              return SkeletonRightDetails();
            })
      ],
    );
  }
}
