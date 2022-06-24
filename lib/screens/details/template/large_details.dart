import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jellyflut/components/logo.dart';
import 'package:jellyflut/components/selectable_back_button.dart';
import 'package:jellyflut/mixins/details_mixin.dart';
import 'package:jellyflut/screens/details/template/components/background_image.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';
import 'package:jellyflut/screens/details/template/async_right_details.dart';
import 'package:jellyflut/screens/details/template/details_background_builder.dart';
import 'package:jellyflut/screens/details/template/components/left_details.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'components/background_image.dart';

class LargeDetails extends StatefulWidget {
  final Item item;
  final String? heroTag;

  const LargeDetails({super.key, required this.item, this.heroTag});

  @override
  State<LargeDetails> createState() => _LargeDetailsState();
}

class _LargeDetailsState extends State<LargeDetails> with DetailsMixin {
  bool isHeaderPinned = false;

  Item get item => widget.item;
  String? get heroTag => widget.heroTag;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      BackgroundImage(item: item, imageType: ImageType.BACKDROP),
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

        return SafeArea(
            child: Stack(alignment: Alignment.topCenter, children: [
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
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        SelectableBackButton(),
                        if (!snapshot.data! && constraints.maxWidth < 960)
                          Logo(
                              item: item,
                              padding: EdgeInsets.symmetric(vertical: 8))
                      ],
                    ),
                  )))
        ]));
      }))
    ]);
  }

  Widget leftDetailsPart(BoxConstraints constraints) {
    if (constraints.maxWidth <= 960) return const SizedBox();
    return Expanded(
        flex: 4,
        child: LeftDetails(
            item: item, heroTag: heroTag, constraints: constraints));
  }

  Widget rightDetailsPart(BoxConstraints constraints) {
    return Expanded(
        flex: 6,
        child: AsyncRightDetails(item: item, constraints: constraints));
  }
}
