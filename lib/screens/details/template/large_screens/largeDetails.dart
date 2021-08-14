import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/detailHeaderBar.dart';
import 'package:jellyflut/screens/details/shared/luminance.dart';
import 'package:jellyflut/screens/details/template/large_screens/leftDetails.dart';
import 'package:jellyflut/screens/details/template/large_screens/rightDetails.dart';
import 'package:jellyflut/screens/details/template/large_screens/skeletonRightDetails.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;
import 'package:palette_generator/palette_generator.dart';

import '../../BackgroundImage.dart';

class LargeDetails extends StatefulWidget {
  final Item item;
  final Future<List<dynamic>> itemToLoad;
  final Future<List<PaletteColor>> paletteColorFuture;
  final String? heroTag;

  LargeDetails(
      {Key? key,
      required this.item,
      required this.itemToLoad,
      required this.paletteColorFuture,
      this.heroTag})
      : super(key: key);

  @override
  _LargeDetailsState createState() => _LargeDetailsState();
}

class _LargeDetailsState extends State<LargeDetails> {
  @override
  Widget build(BuildContext context) {
    return largeScreenTemplate();
  }

  Widget largeScreenTemplate() {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(
        item: widget.item,
        imageType: 'Backdrop',
      ),
      Stack(alignment: Alignment.topCenter, children: [
        Column(children: [
          Expanded(
              child: Row(children: [
            SizedBox(
              height: 64,
            ),
            Expanded(
                flex: 4,
                child: LeftDetails(
                  item: widget.item,
                  heroTag: widget.heroTag ?? '',
                )),
            Expanded(
                flex: 6,
                child: ClipRect(
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
                        child: FutureBuilder<List<PaletteColor>>(
                            future: widget.paletteColorFuture,
                            builder: (context, colorsSnapshot) {
                              if (colorsSnapshot.hasData) {
                                final finalDetailsThemeData =
                                    Luminance.computeLuminance(
                                        colorsSnapshot.data!);
                                return Theme(
                                    data: finalDetailsThemeData,
                                    child: largeWidgetBuilder(
                                        finalDetailsThemeData));
                              }
                              return Theme(
                                  data: personnal_theme.Theme.defaultThemeData,
                                  child: largeWidgetBuilder(
                                      personnal_theme.Theme.defaultThemeData));
                            }))))
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

  Widget largeWidgetBuilder(ThemeData themeData) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                color: themeData.backgroundColor.withOpacity(0.4))),
        Padding(
            padding: const EdgeInsets.all(24),
            child: FutureBuilder<List<dynamic>>(
                future: widget.itemToLoad,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return RightDetails(item: snapshot.data!.elementAt(0));
                  }
                  return SkeletonRightDetails();
                }))
      ],
    );
  }

  Future<List<dynamic>> getItemDelayed() async {
    final futures = <Future>[];
    futures.add(getItem(widget.item.id));
    futures.add(Future.delayed(Duration(milliseconds: 700)));
    return await Future.wait(futures);
  }
}
