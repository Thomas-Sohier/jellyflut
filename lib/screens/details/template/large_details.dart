import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/detail_header_bar.dart';
import 'package:jellyflut/models/details/details_infos.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/background_image.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/left_details.dart';
import 'package:jellyflut/screens/details/template/right_details.dart';
import 'package:jellyflut/screens/details/template/details_background_builder.dart';
import 'package:jellyflut/screens/details/template/skeleton_right_details.dart';

class LargeDetails extends StatefulWidget {
  final Item item;
  final String? heroTag;

  LargeDetails({Key? key, required this.item, this.heroTag}) : super(key: key);

  @override
  _LargeDetailsState createState() => _LargeDetailsState();
}

class _LargeDetailsState extends State<LargeDetails> {
  late final DetailsInfosFuture detailsInfos;

  @override
  void initState() {
    detailsInfos = BlocProvider.of<DetailsBloc>(context).detailsInfos;
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
      DetailsBackgroundBuilder(),
      Stack(alignment: Alignment.topCenter, children: [
        LayoutBuilder(builder: ((_, constraints) {
          return Column(children: [
            Expanded(
                child: Row(children: [
              SizedBox(
                height: 64,
              ),
              if (constraints.maxWidth > 960) leftDetailsPart(),
              rightDetailsPart()
            ]))
          ]);
        }))
      ]),
      DetailHeaderBar(
        color: Colors.white,
        showDarkGradient: false,
        height: 64,
      )
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

  Widget rightDetailsPart() {
    return Expanded(flex: 6, child: asyncRightDetails());
  }

  Widget asyncRightDetails() {
    return FutureBuilder<Item>(
        future: detailsInfos.item,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RightDetails(item: snapshot.data!);
          }
          return SkeletonRightDetails();
        });
  }
}
