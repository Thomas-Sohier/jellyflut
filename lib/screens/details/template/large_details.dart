import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/mixins/details_mixin.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/background_image.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/components/async_right_details.dart';
import 'package:jellyflut/screens/details/template/details_background_builder.dart';
import 'package:jellyflut/screens/details/template/left_details.dart';

class LargeDetails extends StatefulWidget {
  final Item item;
  final String? heroTag;

  const LargeDetails({super.key, required this.item, this.heroTag});

  @override
  State<LargeDetails> createState() => _LargeDetailsState();
}

class _LargeDetailsState extends State<LargeDetails> with DetailsMixin {
  bool isHeaderPinned = false;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(item: widget.item, imageType: ImageType.BACKDROP),
      DetailsBackgroundBuilder(),
      LayoutBuilder(builder: ((_, constraints) {
        // Constraint emitter
        if (constraints.maxWidth <= 960) {
          BlocProvider.of<DetailsBloc>(context)
              .add(DetailsScreenSizeChanged(screenLayout: ScreenLayout.mobile));
        } else {
          BlocProvider.of<DetailsBloc>(context).add(
              DetailsScreenSizeChanged(screenLayout: ScreenLayout.desktop));
        }

        return Stack(alignment: Alignment.topCenter, children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                leftDetailsPart(constraints),
                rightDetailsPart(constraints)
              ]),
          StreamBuilder<bool>(
              initialData: false,
              stream: getDetailsBloc.pinnedHeaderStream,
              builder: (_, snapshot) => AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  left: 0,
                  top: snapshot.data! ? 15 : 0,
                  child: BackButton()))
        ]);
      }))
    ]);
  }

  Widget leftDetailsPart(BoxConstraints constraints) {
    if (constraints.maxWidth <= 960) return const SizedBox();
    return Expanded(
        flex: 4,
        child: LeftDetails(
            item: widget.item,
            heroTag: widget.heroTag,
            constraints: constraints));
  }

  Widget rightDetailsPart(BoxConstraints constraints) {
    return Expanded(
        flex: 6,
        child: AsyncRightDetails(item: widget.item, constraints: constraints));
  }
}
