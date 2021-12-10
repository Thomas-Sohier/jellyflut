import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jellyflut/components/detail_header_bar.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/details/details_infos.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/background_image.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:jellyflut/screens/details/template/right_details.dart';
import 'package:jellyflut/screens/details/template/right_details_background.dart';
import 'package:jellyflut/screens/details/template/skeleton_right_details.dart';

class TabletDetails extends StatefulWidget {
  final Item item;
  final String? heroTag;

  TabletDetails({Key? key, required this.item, this.heroTag}) : super(key: key);

  @override
  _TabletDetailsState createState() => _TabletDetailsState();
}

class _TabletDetailsState extends State<TabletDetails> {
  late final DetailsInfosFuture detailsInfos;

  @override
  void initState() {
    detailsInfos = BlocProvider.of<DetailsBloc>(context).detailsInfos;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return tabletScreenTemplate();
  }

  Widget tabletScreenTemplate() {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(
        item: widget.item,
        imageType: ImageType.BACKDROP,
      ),
      RightDetailsBackground(
          dominantColorFuture: detailsInfos.dominantColor,
          child: detailsBuilder()),
      DetailHeaderBar(
        color: Colors.white,
        showDarkGradient: false,
        height: 64,
      ),
    ]);
  }

  Widget detailsBuilder() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 82, 24, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            poster(),
            if (widget.item.hasLogo()) Flexible(child: Logo(item: widget.item)),
          ],
        ),
        asyncRightDetails()
      ],
    );
  }

  Widget asyncRightDetails() {
    return FutureBuilder<Item>(
        future: detailsInfos.item,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RightDetails(
                item: snapshot.data!,
                dominantColorFuture: detailsInfos.dominantColor);
          }
          return SkeletonRightDetails();
        });
  }

  Widget poster() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: itemPosterHeight),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: AspectRatio(
          aspectRatio: widget.item.getPrimaryAspectRatio(showParent: true),
          child: Poster(
            item: widget.item,
            boxFit: BoxFit.cover,
            clickable: false,
            showParent: true,
            tag: ImageType.PRIMARY,
            heroTag: widget.heroTag,
          ),
        ),
      ),
    );
  }
}
