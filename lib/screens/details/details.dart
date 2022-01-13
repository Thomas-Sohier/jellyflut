import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/details/details_infos.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/large_details.dart';
import 'package:jellyflut/screens/details/template/tablet_details.dart';
import 'package:jellyflut/services/item/item_image_service.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/responsive_builder.dart';
import 'package:jellyflut/shared/utils/blurhash_util.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:rxdart/subjects.dart';

import 'components/photo_item.dart';

class Details extends StatefulWidget {
  final Item item;
  final String? heroTag;

  const Details({required this.item, required this.heroTag});

  @override
  State<StatefulWidget> createState() {
    return _DetailsState();
  }
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  late final DetailsBloc detailsBloc;

  @override
  void initState() {
    detailsBloc = DetailsBloc(getDetailsInfos());
    super.initState();
  }

  @override
  void dispose() {
    detailsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MusicPlayerFAB(
        child: BlocProvider<DetailsBloc>(
            create: (context) => detailsBloc,
            child: Scaffold(
                extendBody: true,
                backgroundColor: Colors.transparent,
                body: BlocListener<DetailsBloc, DetailsState>(
                    bloc: detailsBloc,
                    listener: (context, state) {
                      if (state is DetailsLoadedState) {
                        setState(() {});
                      }
                    },
                    child: widget.item.type != ItemType.PHOTO
                        ? responsiveBuilder()
                        : PhotoItem(
                            item: widget.item, heroTag: widget.heroTag)))));
  }

  Widget responsiveBuilder() {
    return ResponsiveBuilder.builder(
        mobile: () => TabletDetails(item: widget.item, heroTag: widget.heroTag),
        tablet: () => TabletDetails(item: widget.item, heroTag: widget.heroTag),
        desktop: () =>
            LargeDetails(item: widget.item, heroTag: widget.heroTag));
  }

  DetailsInfosFuture getDetailsInfos() {
    final item = offlineMode
        ? Future.value(widget.item)
        : ItemService.getItem(widget.item.id);
    final primaryUrl = ItemImageService.getItemImageUrl(widget.item.id,
        widget.item.correctImageTags(searchType: ImageType.PRIMARY),
        type: widget.item.correctImageType(searchType: ImageType.PRIMARY),
        quality: 40);

    NetworkAssetBundle(Uri.parse(primaryUrl))
        .load(primaryUrl)
        .then((ByteData byteData) {
      final imageBytes = byteData.buffer.asUint8List();
      final colors = compute(ColorUtil.extractPixelsColors, imageBytes);
      detailsBloc.add(DetailsUpdateColor(colors: colors));
    });
    return DetailsInfosFuture(
        item: item,
        dominantColor:
            BehaviorSubject<Future<List<Color>>>.seeded(Future.value([])));
  }
}
