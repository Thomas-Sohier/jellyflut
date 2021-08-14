import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/BackgroundImage.dart';
import 'package:jellyflut/screens/details/detailHeaderBar.dart';
import 'package:jellyflut/screens/details/shared/luminance.dart';
import 'package:jellyflut/screens/details/template/large_screens/rightDetails.dart';
import 'package:jellyflut/screens/details/template/large_screens/skeletonRightDetails.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;
import 'package:palette_generator/palette_generator.dart';

class TabletDetails extends StatefulWidget {
  final Item item;
  final Future<List<dynamic>> itemToLoad;
  final Future<List<PaletteColor>> paletteColorFuture;
  final String? heroTag;

  TabletDetails(
      {Key? key,
      required this.item,
      required this.itemToLoad,
      required this.paletteColorFuture,
      this.heroTag})
      : super(key: key);

  @override
  _TabletDetailsState createState() => _TabletDetailsState();
}

class _TabletDetailsState extends State<TabletDetails> {
  @override
  Widget build(BuildContext context) {
    return tabletScreenTemplate();
  }

  Widget tabletScreenTemplate() {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(
        item: widget.item,
        imageType: 'Backdrop',
      ),
      ClipRect(
          child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 17.0, sigmaY: 17.0),
        child: FutureBuilder<List<PaletteColor>>(
            future: widget.paletteColorFuture,
            builder: (context, colorsSnapshot) {
              if (colorsSnapshot.hasData) {
                final finalDetailsThemeData =
                    Luminance.computeLuminance(colorsSnapshot.data!);
                return Theme(
                    data: finalDetailsThemeData,
                    child: detailsBuilder(finalDetailsThemeData));
              }
              return Theme(
                  data: personnal_theme.Theme.defaultThemeData,
                  child:
                      detailsBuilder(personnal_theme.Theme.defaultThemeData));
            }),
      )),
      DetailHeaderBar(
        color: Colors.white,
        showDarkGradient: false,
        height: 64,
      ),
    ]);
  }

  Widget detailsBuilder(ThemeData themeData) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                color: themeData.backgroundColor.withOpacity(0.4))),
        Padding(
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
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
}
