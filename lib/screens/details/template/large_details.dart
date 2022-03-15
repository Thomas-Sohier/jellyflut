import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/details/details_infos.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/background_image.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:jellyflut/screens/details/template/details_background_builder.dart';
import 'package:jellyflut/screens/details/template/left_details.dart';
import 'package:jellyflut/screens/details/template/right_details.dart';
import 'package:jellyflut/screens/details/template/skeleton_right_details.dart';

class LargeDetails extends StatefulWidget {
  final Item item;
  final String? heroTag;

  LargeDetails({Key? key, required this.item, this.heroTag}) : super(key: key);

  @override
  _LargeDetailsState createState() => _LargeDetailsState();
}

class _LargeDetailsState extends State<LargeDetails> {
  late ThemeData theme;
  final List<Color> gradient = [];
  late final DetailsBloc _detailsBloc;
  late final DetailsInfosFuture detailsInfos;

  @override
  void initState() {
    _detailsBloc = BlocProvider.of<DetailsBloc>(context);
    detailsInfos = _detailsBloc.detailsInfos;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(
        item: widget.item,
        imageType: ImageType.BACKDROP,
      ),
      DetailsBackgroundBuilder(),
      LayoutBuilder(builder: ((_, constraints) {
        return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (constraints.maxWidth > 960) leftDetailsPart(),
              rightDetailsPart(constraints)
            ]);
      }))
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

  Widget rightDetailsPart(BoxConstraints constraints) {
    return Expanded(flex: 6, child: asyncRightDetails(constraints));
  }

  Widget asyncRightDetails(BoxConstraints constraints) {
    return BlocConsumer<DetailsBloc, DetailsState>(
        bloc: _detailsBloc,
        listener: (_, detailsState) => {},
        builder: (_, detailsState) {
          return FutureBuilder<Item>(
              future: detailsState.detailsInfosFuture.item,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RightDetails(
                      item: snapshot.data!,
                      posterAndLogoWidget: posterAndLogoWidget(constraints));
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 48),
                      posterAndLogoWidget(constraints),
                      Flexible(child: SkeletonRightDetails()),
                    ],
                  ),
                );
              });
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
