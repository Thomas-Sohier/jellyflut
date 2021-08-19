import 'package:flutter/material.dart';
import 'package:jellyflut/components/musicPlayerFAB.dart';
import 'package:jellyflut/models/details/detailsInfos.dart';
import 'package:jellyflut/models/enum/imageType.dart';
import 'package:jellyflut/models/enum/itemType.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/template/small_screens/details.dart'
    as phone;
import 'package:jellyflut/screens/details/template/large_screens/largeDetails.dart';
import 'package:jellyflut/screens/details/template/large_screens/tabletDetails.dart';
import 'package:jellyflut/services/item/itemService.dart';
import 'package:jellyflut/shared/blurhash.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../globals.dart';
import 'components/photoItem.dart';

class Details extends StatefulWidget {
  final Item item;
  final String heroTag;

  const Details({required this.item, required this.heroTag});

  @override
  State<StatefulWidget> createState() {
    return _DetailsState();
  }
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  late final DetailsInfos futureDetailsInfos;

  @override
  void initState() {
    futureDetailsInfos = getDetailsInfos();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MusicPlayerFAB(
      child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: widget.item.type != ItemType.PHOTO
              ? responsiveBuilder()
              : PhotoItem(item: widget.item, heroTag: widget.heroTag)),
    );
  }

  Widget responsiveBuilder() {
    return ScreenTypeLayout.builder(
        breakpoints: screenBreakpoints,
        mobile: (BuildContext context) => phone.Details(
              item: widget.item,
              itemToLoad: futureDetailsInfos.item,
              dominantColorFuture: futureDetailsInfos.dominantColor,
              heroTag: widget.heroTag,
            ),
        tablet: (BuildContext context) => TabletDetails(
              item: widget.item,
              itemToLoad: futureDetailsInfos.item,
              dominantColorFuture: futureDetailsInfos.dominantColor,
              heroTag: widget.heroTag,
            ),
        desktop: (BuildContext context) => LargeDetails(
            item: widget.item,
            itemToLoad: futureDetailsInfos.item,
            dominantColorFuture: futureDetailsInfos.dominantColor,
            heroTag: widget.heroTag));
  }

  DetailsInfos getDetailsInfos() {
    final futureItem = ItemService.getItem(widget.item.id);
    final dominantColorFuture =
        BlurHashUtil.getDominantColor(widget.item, ImageType.PRIMARY);
    final futureDetailsInfos =
        DetailsInfos(item: futureItem, dominantColor: dominantColorFuture);
    return futureDetailsInfos;
  }
}
