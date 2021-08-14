import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/card/cardItemWithChild.dart';
import 'package:jellyflut/components/paletteButton.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/BackgroundImage.dart';
import 'package:jellyflut/screens/details/components/collection.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:jellyflut/screens/details/detailHeaderBar.dart';
import 'package:jellyflut/shared/theme.dart' as personnal_theme;
import 'package:palette_generator/palette_generator.dart';

class Details extends StatefulWidget {
  final Item item;
  final Future<List<dynamic>> itemToLoad;
  final Future<List<PaletteColor>> paletteColorFuture;
  final String? heroTag;

  Details(
      {Key? key,
      required this.item,
      required this.itemToLoad,
      required this.paletteColorFuture,
      this.heroTag})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late final ThemeData cardThemeData;

  @override
  void initState() {
    cardThemeData = personnal_theme.Theme.defaultThemeData.copyWith(
        textTheme: personnal_theme.Theme.getTextThemeWithColor(Colors.black),
        primaryTextTheme:
            personnal_theme.Theme.getTextThemeWithColor(Colors.black));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(data: cardThemeData, child: phoneTemplate());
  }

  Widget phoneTemplate() {
    final mediaQuery = MediaQuery.of(context);
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(
        item: widget.item,
        imageType: 'Primary',
      ),
      Stack(alignment: Alignment.topCenter, children: [
        Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(children: [
              SizedBox(
                height: 64,
              ),
              if (widget.item.hasLogo())
                Logo(item: widget.item, size: mediaQuery.size),
              if (!widget.item.hasLogo())
                SizedBox(
                  height: 64,
                  width: double.infinity,
                ),
              card(),
              Collection(widget.item),
            ])),
        DetailHeaderBar(
          color: Colors.white,
          height: 64,
        ),
      ])
    ]);
  }

  Widget card() {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 25),
              child: CardItemWithChild(
                itemsToLoad: widget.itemToLoad,
              )),
          widget.item.isPlayable()
              ? ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: mediaQuery.size.width * 0.5),
                  child: PaletteButton(
                    'Play',
                    () {
                      widget.item.playItem();
                    },
                    item: widget.item,
                    icon: Icon(Icons.play_circle_outline),
                  ),
                )
              : Container()
        ]);
  }
}
