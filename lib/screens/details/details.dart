import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/music_player_FAB.dart';
import 'package:jellyflut/models/details/details_infos.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/large_details.dart';
import 'package:jellyflut/screens/details/template/tablet_details.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/shared/responsive_builder.dart';
import 'package:jellyflut/shared/utils/blurhash_util.dart';

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
        child: BlocProvider(
            create: (context) => detailsBloc,
            child: Scaffold(
                extendBody: true,
                backgroundColor: Colors.transparent,
                body: widget.item.type != ItemType.PHOTO
                    ? responsiveBuilder()
                    : PhotoItem(item: widget.item, heroTag: widget.heroTag))));
  }

  Widget responsiveBuilder() {
    return ResponsiveBuilder.builder(
        mobile: () => TabletDetails(item: widget.item, heroTag: widget.heroTag),
        tablet: () => TabletDetails(item: widget.item, heroTag: widget.heroTag),
        desktop: () =>
            LargeDetails(item: widget.item, heroTag: widget.heroTag));
  }

  DetailsInfosFuture getDetailsInfos() {
    final item = ItemService.getItem(widget.item.id);
    final dominantColor =
        BlurHashUtil.getDominantColor(widget.item, ImageType.PRIMARY);
    return DetailsInfosFuture(item: item, dominantColor: dominantColor);
  }
}
