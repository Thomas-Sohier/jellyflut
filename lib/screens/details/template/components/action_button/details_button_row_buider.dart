import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../action_button.dart';

class DetailsButtonRowBuilder extends StatelessWidget {
  final Item item;
  final Future<Color> dominantColorFuture;
  const DetailsButtonRowBuilder(
      {Key? key, required this.item, required this.dominantColorFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(MediaQuery.of(context).size);
    if (deviceType == DeviceScreenType.mobile) {
      return mobileButtonsLayout();
    }
    return desktopButtonsLayout();
  }

  Widget desktopButtonsLayout() {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 10,
      runSpacing: 10,
      children: [
        if (item.isPlayable())
          PlayButton(item: item, dominantColorFuture: dominantColorFuture),
        if (item.hasTrailer()) TrailerButton(item: item),
        if (item.canBeViewed()) ViewedButton(item: item),
        LikeButton(item: item),
        ManageButton(item: item)
      ],
    );
  }

  Widget mobileButtonsLayout() {
    return Column(
      children: [
        if (item.isPlayable())
          PlayButton(
            item: item,
            dominantColorFuture: dominantColorFuture,
            maxWidth: double.maxFinite,
          ),
        SizedBox(height: 10),
        LayoutBuilder(builder: (context, constraints) {
          final nbItemsPossible = (constraints.maxWidth / 150).round() > 4
              ? 4
              : (constraints.maxWidth / 150).round();
          final nbOfspacing = nbItemsPossible - 1;
          final maxWidthChild =
              (constraints.maxWidth - nbOfspacing * 10) / nbItemsPossible;
          return Wrap(
            direction: Axis.horizontal,
            spacing: 10,
            runSpacing: 10,
            children: [
              if (item.hasTrailer())
                TrailerButton(item: item, maxWidth: maxWidthChild),
              if (item.canBeViewed())
                ViewedButton(item: item, maxWidth: maxWidthChild),
              LikeButton(item: item, maxWidth: maxWidthChild),
              ManageButton(item: item, maxWidth: maxWidthChild)
            ],
          );
        })
      ],
    );
  }
}
