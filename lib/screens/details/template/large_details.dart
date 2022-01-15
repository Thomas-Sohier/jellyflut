import 'dart:async';

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
import 'package:jellyflut/screens/details/shared/luminance.dart';
import 'package:jellyflut/screens/details/template/left_details.dart';
import 'package:jellyflut/screens/details/template/right_details.dart';
import 'package:jellyflut/screens/details/template/details_background_builder.dart';
import 'package:jellyflut/screens/details/template/skeleton_right_details.dart';
import 'package:jellyflut/shared/utils/color_util.dart';

class LargeDetails extends StatefulWidget {
  final Item item;
  final String? heroTag;

  LargeDetails({Key? key, required this.item, this.heroTag}) : super(key: key);

  @override
  _LargeDetailsState createState() => _LargeDetailsState();
}

class _LargeDetailsState extends State<LargeDetails> {
  late final DetailsInfosFuture detailsInfos;
  final List<Color> gradient = [];
  late final DetailsBloc bloc;
  late final StreamSubscription<List<Color>> sub;
  Color? paletteColor1;
  Color? paletteColor2;
  late Color leftColor;
  late Color rightColor;
  late ThemeData theme;

  @override
  void initState() {
    detailsInfos = BlocProvider.of<DetailsBloc>(context).detailsInfos;

    // listening to stream and then update colors is way more performant than
    //doing this in the build method as before
    bloc = BlocProvider.of<DetailsBloc>(context);
    sub = bloc.gradientStream.stream.listen((event) {});
    sub.onData(updateColor);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
  }

  void updateColor(List<Color> colors) {
    if (colors.isNotEmpty) {
      setState(() {
        paletteColor1 =
            ColorUtil.changeColorSaturation(colors[1], 0.5).withOpacity(0.60);
        paletteColor2 =
            ColorUtil.changeColorSaturation(colors[2], 0.5).withOpacity(0.60);
        final middleColor =
            Color.lerp(paletteColor1, paletteColor2, 0.5) ?? rightColor;
        theme = Luminance.computeLuminance(middleColor);
      });
    }
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: Stack(alignment: Alignment.topCenter, children: [
        BackgroundImage(
          item: widget.item,
          imageType: ImageType.BACKDROP,
        ),
        DetailsBackgroundBuilder(
            colors: (paletteColor1 != null && paletteColor2 != null)
                ? [paletteColor1!, paletteColor2!]
                : []),
        Stack(alignment: Alignment.topCenter, children: [
          LayoutBuilder(builder: ((_, constraints) {
            return Column(children: [
              Expanded(
                  child: Row(children: [
                SizedBox(
                  height: 64,
                ),
                if (constraints.maxWidth > 960) leftDetailsPart(),
                rightDetailsPart(constraints)
              ]))
            ]);
          }))
        ]),
        DetailHeaderBar(
          color: Colors.white,
          showDarkGradient: false,
          height: 64,
        )
      ]),
    );
  }

  Widget leftDetailsPart() {
    return Expanded(
        flex: 4,
        child: LeftDetails(
          item: widget.item,
          heroTag: widget.heroTag,
        ));
  }

  Widget rightDetailsPart(BoxConstraints constraints) {
    return Expanded(flex: 6, child: asyncRightDetails(constraints));
  }

  Widget asyncRightDetails(BoxConstraints constraints) {
    return FutureBuilder<Item>(
        future: detailsInfos.item,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RightDetails(
                item: snapshot.data!,
                posterAndLogoWidget: posterAndLogoWidget(constraints));
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 48),
              posterAndLogoWidget(constraints),
              Flexible(child: SkeletonRightDetails()),
            ],
          );
        });
  }

  Widget posterAndLogoWidget(BoxConstraints constraints) {
    return OverflowBar(
        alignment: MainAxisAlignment.spaceEvenly,
        overflowAlignment: OverflowBarAlignment.center,
        overflowDirection: VerticalDirection.down,
        overflowSpacing: 10,
        spacing: 20,
        children: [
          if (constraints.maxWidth < 960) poster(),
          if (widget.item.hasLogo()) Logo(item: widget.item),
        ]);
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
